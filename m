Return-Path: <linux-kernel-owner+w=401wt.eu-S967374AbXHMP4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967374AbXHMP4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S945812AbXHMOQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 10:16:24 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:44108 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S946616AbXHMOQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 10:16:20 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [PATCH 0/2][KVM] guest time accounting
Date: Mon, 13 Aug 2007 16:15:42 +0200
User-Agent: KMail/1.9.7
Cc: Laurent Vivier <Laurent.Vivier@bull.net>, Avi Kivity <avi@qumranet.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       cotte@de.ibm.com
References: <46BC8B39.6050202@bull.net> <46C00FC1.1070306@qumranet.com> <46C012A8.2040908@bull.net>
In-Reply-To: <46C012A8.2040908@bull.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708131615.42643.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 13. August 2007 schrieb Laurent Vivier:
> > [copying Ingo and Rusty]

@Avi, seems that sourceforge is mangling the cc list?

> > 
> > The patches look good.  A couple of comments:
> > 
> > - perhaps the new fields should be guarded by a #ifdef CONFIG_HYPERVISOR
> > (selected by CONFIG_KVM)?  that way the (minor) additional overhead is
> > only incurred if it can possibly be used.  I imagine that our canine
> > cousin will want to use this as well.
> 
> There is also a CONFIG_VIRTUALIZATION and a CONFIG_VIRT_CPU_ACCOUNTING (from
> s390 and powerpc) Which one to use ?

CONFIG_VIRT_CPU_ACCOUNTING is used for the precise accouting of user,system, 
steal and irq time on these platforms and is not what you want for the on/off 
decision. 
> 
> I'm wondering if we can have a more accurate accounting:
> 
> - For the moment we add all system time since the previous entering to the
> VCPU to the guest time (and I guess there is some real system time in
> it ???) 
> - Perhaps we can sum nanoseconds spent in the VCPU and add it to cpustat
> when these ns are greater than 1 ms ? (I'm trying to make something in this 
way)

If you look at the patch I have posted some minutes ago, I use a method 
similar to irq_enter and irq_exit to separate real system time from guest 
time. 

> > - I think that there is per-task accounting of user time and system
> > time; that should be extended as well.
> it should be easy to do too...

We have to make sure that userspace doesnt break, but yes we should have a 
guest time for processes as well. 

Christian
