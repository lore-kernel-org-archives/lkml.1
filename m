Return-Path: <linux-kernel-owner+w=401wt.eu-S1758956AbXEJPdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956AbXEJPdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 11:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbXEJPda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 11:33:30 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:37863 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbXEJPd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 11:33:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=PkDs4u5Ua4QX0VAJ5KFf+mGDK8OeWdAYntwTpVlIGqkoNQnZbb7pq2NqpP7UxX7d+lpGSRaU3CFV/c3m9YQCPiQp1G67UHsc/mBtsr0fCt+wVCUcjMTu8n9svVise3tLak0V39SjQ+ZSVBF991swOGHFBXamP+tpFtK55itW0do=
Message-ID: <3ae72650705100833h35dbc5fer7553529d643c742c@mail.gmail.com>
Date: Thu, 10 May 2007 17:33:27 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: [PATCH] driver-core: don't free devt_attr till the device is released
Cc: "Greg KH" <greg@kroah.com>, "Chris Rankin" <rankincj@yahoo.com>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
In-Reply-To: <46432FFD.1040304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <602729.80444.qm@web52910.mail.re2.yahoo.com>
	 <4641CD01.6010309@gmail.com> <20070509145747.GA27259@kroah.com>
	 <4641E245.7040603@gmail.com> <20070509154039.GA27681@kroah.com>
	 <46432FFD.1040304@gmail.com>
X-Google-Sender-Auth: 7f039bb7cceec90b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/10/07, Tejun Heo <htejun@gmail.com> wrote:
> Currently, devt_attr for the "dev" file is freed immediately on device
> removal, but if the "dev" sysfs file is open when a device is removed,
> sysfs will access its attribute structure for further access including
> close resulting in jumping to garbled address.  Fix it by postponing
> freeing devt_attr to device release time.
>
> Note that devt_attr for class_device is already freed on release.

Hi Tejun,
your rework removes the "owner" field from the attributes. I think we
kept the "dev" and "uevent" attribute as part of "struct device" only
to be able to assign it the actual owner of the module that has
created the device. The attribute can probably just live as one
instance statically in the driver core now?

Thanks,
Kay
