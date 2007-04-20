Return-Path: <linux-kernel-owner+w=401wt.eu-S2993078AbXDTR7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993078AbXDTR7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 13:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993110AbXDTR7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 13:59:44 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:54858 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993078AbXDTR7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 13:59:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Cnp9oeHakh54XcYglkmh+rvSOopB846RI/6iBGbYqBNm97r73CgZqY6og5tZ/DLWPguxN64mgHI7XPmlOsLypqEqao4GQMRS8mNBg1Pn7owqQTzARl7oiVRSPlyOxpVzxmNsbpU0K1UdVLy3THntFjzP/rCT+5teUAAS7hPl1sQ=
Message-ID: <d120d5000704201059o750cc95am349707d353f79f10@mail.gmail.com>
Date: Fri, 20 Apr 2007 13:59:41 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
Cc: "Cornelia Huck" <cornelia.huck@de.ibm.com>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Greg K-H" <greg@kroah.com>, "Rusty Russell" <rusty@rustcorp.com.au>
In-Reply-To: <4628EFB2.9070709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.44L0.0704181032060.12246-100000@iolanthe.rowland.org>
	 <46263A82.1030703@gmail.com>
	 <d120d5000704180941pe2ab181xb5eab63b7cc1b297@mail.gmail.com>
	 <20070419145133.2f7ed45a@gondolin.boeblingen.de.ibm.com>
	 <d120d5000704190613h178ad644h53ad817db2950426@mail.gmail.com>
	 <20070419154849.2e722762@gondolin.boeblingen.de.ibm.com>
	 <d120d5000704190721u16be1110ufe04880eded7d54e@mail.gmail.com>
	 <462856B9.9010307@gmail.com>
	 <d120d5000704200935r2fb1e614m6da149eee0aec5b6@mail.gmail.com>
	 <4628EFB2.9070709@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/20/07, Tejun Heo <htejun@gmail.com> wrote:
> Hello, Dmitry.
>
> Dmitry Torokhov wrote:
> >> Many drivers (at least all the SCSI/IDE ones) consider struct device as
> >> the base class of the devices those drivers implement.  I don't think we
> >> can just consider those drivers to be wrong.
> >
> > I am not saying they are wrong I am just saying that driver core is
> > not where most work is done. Every subsystem has its own locking rules
> > and lifetime rules and they are what is important. Whether subsystem
> > uses embedding or referencing of struct devices is implementation
> > detail.
> >
> > What is the goal of driver core? I thought the main goal was to have
> > an uniform interface for device power management and presentation of
> > device tree to userspace. It has nothing to do with main purposes of
> > every individual subsystem - making some set of devices/services work.
>
> I think we're running in circle here.
>
> 1. The driver's lifetime rules matters but currently the driver model
> imposes reference counted model to each struct device.
>
> 2. You can decouple struct device completely from actual driver
> implementation.
>
> I agree with you that #2 is possible but just don't think it's the right
> thing to do.  By making struct device independent from driver
> implementation doesn't help solving lifetime problems in drivers.  It
> just insulates driver model from those.
>

Isn't think a good thing? By decoupling the 2 layers we insulate them
from changes in each other. This allows bug subsystems to concentrate
on topics that important to them instead of worying about refcounting
objects that are not directly interesting for the subsystem in
question.

Now for smaller subsystems it may make sense to embed stuct devices
into subsystem objects and manage it all together. In fact input
system does this but I think it is much simlpier than SCSI or IDE.

-- 
Dmitry
