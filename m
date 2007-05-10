Return-Path: <linux-kernel-owner+w=401wt.eu-S1759304AbXEJPmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304AbXEJPmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 11:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbXEJPmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 11:42:09 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:57088 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbXEJPmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 11:42:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=QHoeNOYnf0XURaVLcs2pt/5JRxsLLf8FaIoi0zCNovSBlaHJEo+zBsfmZMJIaO2H+0JZJ0Jp5b6xPgaN/tB9i2LOjxcLO32V1kVfpRsEcwF8IuRfDXNMlSNbUD9pNGpmKRhUxgOwliac9b4yYxXdt7x8wrZEg8yPpJuQQrzFLgY=
Message-ID: <46433D42.2060101@gmail.com>
Date: Thu, 10 May 2007 17:41:54 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Greg KH <greg@kroah.com>, Chris Rankin <rankincj@yahoo.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [PATCH] driver-core: don't free devt_attr till the device is
 released
References: <602729.80444.qm@web52910.mail.re2.yahoo.com>	 <4641CD01.6010309@gmail.com> <20070509145747.GA27259@kroah.com>	 <4641E245.7040603@gmail.com> <20070509154039.GA27681@kroah.com>	 <46432FFD.1040304@gmail.com> <3ae72650705100833h35dbc5fer7553529d643c742c@mail.gmail.com>
In-Reply-To: <3ae72650705100833h35dbc5fer7553529d643c742c@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On 5/10/07, Tejun Heo <htejun@gmail.com> wrote:
>> Currently, devt_attr for the "dev" file is freed immediately on device
>> removal, but if the "dev" sysfs file is open when a device is removed,
>> sysfs will access its attribute structure for further access including
>> close resulting in jumping to garbled address.  Fix it by postponing
>> freeing devt_attr to device release time.
>>
>> Note that devt_attr for class_device is already freed on release.
> 
> Hi Tejun,
> your rework removes the "owner" field from the attributes. I think we
> kept the "dev" and "uevent" attribute as part of "struct device" only
> to be able to assign it the actual owner of the module that has
> created the device. The attribute can probably just live as one
> instance statically in the driver core now?

Yeah, that's -mm and this is for -stable and -22.  For -mm, we can just
make all those attributes static which is the other patch is this
thread.  :-)

-- 
tejun
