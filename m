Return-Path: <linux-kernel-owner+w=401wt.eu-S1422936AbXDTF7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422936AbXDTF7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 01:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422919AbXDTF7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 01:59:31 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:57275 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422651AbXDTF7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 01:59:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=XKzIqx2FYEzU7DTzKAqDJVvHw9+xrM06NMxQe4OnzskeEd/bqaTZ75r4b1jKkVbzF2DxtjOY8klos5cfO9ppcnrtWaz7Fl76aeLEAR/KNmzIMefeoVfTC2Rzu9Kv8EbV4dUm+CXEnZYY9u7lS23WucXN6XNKWMs5Pw1CmcwfM9M=
Message-ID: <462856B9.9010307@gmail.com>
Date: Fri, 20 Apr 2007 14:59:21 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg K-H <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
References: <Pine.LNX.4.44L0.0704181032060.12246-100000@iolanthe.rowland.org>	 <46263A82.1030703@gmail.com>	 <d120d5000704180941pe2ab181xb5eab63b7cc1b297@mail.gmail.com>	 <20070419145133.2f7ed45a@gondolin.boeblingen.de.ibm.com>	 <d120d5000704190613h178ad644h53ad817db2950426@mail.gmail.com>	 <20070419154849.2e722762@gondolin.boeblingen.de.ibm.com> <d120d5000704190721u16be1110ufe04880eded7d54e@mail.gmail.com>
In-Reply-To: <d120d5000704190721u16be1110ufe04880eded7d54e@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Dmitry.

Dmitry Torokhov wrote:
> On 4/19/07, Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
>> On Thu, 19 Apr 2007 09:13:43 -0400,
>> "Dmitry Torokhov" <dmitry.torokhov@gmail.com> wrote:
>>
>> > Because they are managed by 2 different entities. the struct device
>> > objects are managed by device core and driver-specific objects are
>> > managed by their respective driver.
>>
>> Not sure if I understand you here. My view of this was always that the
>> embedding object was kind of an extended device and that the relevant
>> driver/subsystem managed it through the driver core infrastructure.
>>
> 
> I am not sure if I agree with this point of view. Driver (or
> subsystem) provides an instance of struct device for the rest of the
> system to iteract uniformly with (suspend/resume/tree
> visualization/etc) i.e. struct device implement an interface for
> subsystems. However most of the system use their own mechanisms to
> manage their devices. They can rely on the driver core to a certain
> degree but driver core is mostly a carries out helper functions, not
> the meat.

Many drivers (at least all the SCSI/IDE ones) consider struct device as
the base class of the devices those drivers implement.  I don't think we
can just consider those drivers to be wrong.

-- 
tejun
