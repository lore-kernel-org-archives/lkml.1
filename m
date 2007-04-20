Return-Path: <linux-kernel-owner+w=401wt.eu-S1767152AbXDTQwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767152AbXDTQwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 12:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767153AbXDTQwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 12:52:11 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:2755 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767152AbXDTQwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 12:52:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=eTEx3z0xi/sPHFhdMDr3tUAmdbS7vAHeyMOusoWL5C1Ys/j3s6aRvBqQEiNfOqLTDVjm1ZSOb81USDqIw2ccXKdf6Zal803tCud0DtucY4r8O7BdEsH42/TDh6cslY9TqN5cnsKVmEpYBOsqS+72A3k/0cRbuJf2Ps6TWtReMfE=
Message-ID: <4628EFB2.9070709@gmail.com>
Date: Sat, 21 Apr 2007 01:52:02 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg K-H <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
References: <Pine.LNX.4.44L0.0704181032060.12246-100000@iolanthe.rowland.org>	 <46263A82.1030703@gmail.com>	 <d120d5000704180941pe2ab181xb5eab63b7cc1b297@mail.gmail.com>	 <20070419145133.2f7ed45a@gondolin.boeblingen.de.ibm.com>	 <d120d5000704190613h178ad644h53ad817db2950426@mail.gmail.com>	 <20070419154849.2e722762@gondolin.boeblingen.de.ibm.com>	 <d120d5000704190721u16be1110ufe04880eded7d54e@mail.gmail.com>	 <462856B9.9010307@gmail.com> <d120d5000704200935r2fb1e614m6da149eee0aec5b6@mail.gmail.com>
In-Reply-To: <d120d5000704200935r2fb1e614m6da149eee0aec5b6@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Dmitry.

Dmitry Torokhov wrote:
>> Many drivers (at least all the SCSI/IDE ones) consider struct device as
>> the base class of the devices those drivers implement.  I don't think we
>> can just consider those drivers to be wrong.
> 
> I am not saying they are wrong I am just saying that driver core is
> not where most work is done. Every subsystem has its own locking rules
> and lifetime rules and they are what is important. Whether subsystem
> uses embedding or referencing of struct devices is implementation
> detail.
> 
> What is the goal of driver core? I thought the main goal was to have
> an uniform interface for device power management and presentation of
> device tree to userspace. It has nothing to do with main purposes of
> every individual subsystem - making some set of devices/services work.

I think we're running in circle here.

1. The driver's lifetime rules matters but currently the driver model
imposes reference counted model to each struct device.

2. You can decouple struct device completely from actual driver
implementation.

I agree with you that #2 is possible but just don't think it's the right
thing to do.  By making struct device independent from driver
implementation doesn't help solving lifetime problems in drivers.  It
just insulates driver model from those.

-- 
tejun
