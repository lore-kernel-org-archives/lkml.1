Return-Path: <linux-kernel-owner+w=401wt.eu-S934570AbYEUGef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934570AbYEUGef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 02:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758481AbYEUGe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 02:34:27 -0400
Received: from relay2.sgi.com ([192.48.171.30]:34663 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758202AbYEUGe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 02:34:26 -0400
Date: Wed, 21 May 2008 01:34:24 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: a.p.zijlstra@chello.nl, menage@google.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: IRQ affinities
Message-Id: <20080521013424.6600780a.pj@sgi.com>
In-Reply-To: <48337792.20606@qualcomm.com>
References: <47D73086.2030008@qualcomm.com>
	<6599ad830803111827n1cb8e2c7i47c2ef3f3bb58995@mail.gmail.com>
	<47D7411E.1000009@qualcomm.com>
	<6599ad830803111936jd940deam8584bc971c3b6f41@mail.gmail.com>
	<47D74595.4080100@qualcomm.com>
	<6599ad830803112009y18d9e43ft8e3fc4a551d891da@mail.gmail.com>
	<20080311235939.1ebee8e3.pj@sgi.com>
	<47D81FE1.6030205@qualcomm.com>
	<20080312135746.89456f2a.pj@sgi.com>
	<47D82AD2.1070108@qualcomm.com>
	<20080312143253.3dd72c7f.pj@sgi.com>
	<47D83858.4030806@qualcomm.com>
	<20080312153712.bc5df7a1.pj@sgi.com>
	<47D8593A.6040503@qualcomm.com>
	<20080312183059.6716d630.pj@sgi.com>
	<47D87BE5.4010702@qualcomm.com>
	<20080313020300.92244956.pj@sgi.com>
	<47FE5655.10900@qualcomm.com>
	<20080414133902.7878cfce.pj@sgi.com>
	<1210329926.13978.224.camel@twins>
	<20080509061727.5057de1f.pj@sgi.com>
	<48337792.20606@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max wrote:
> What I realized now is that all I need is
> /proc/irq/default_smp_affinity.

I suspect that something like you're proposing to do here will answer
your needs, to "tell the kernel to not route IRQs to certain CPUs."

I suspect that other folks will have some additional needs, that perhaps
my idea of May 9, 2008:

       How about this.  We add two files to each cpuset:
       
           irq_affinity_include	# IRQs to direct to CPUs in this cpuset
           irq_affinity_exclude	# IRQs -not- to direct to these CPUs
       
       where irq_affinity_exclude overrides irq_affinity_include.

could meet.

It makes sense to me to deal with your "default_smp_affinity" patch
first, and then come back around and see what remains to be done, and
how to do it, perhaps with additional cpuset based mechanisms such as
the above two irq_affinity_* IRQ masks.

> I'm in the process of making a patch for exposing default affinity mask.

Peter, et al: how does Max's planned "default_smp_affinity" patch sound
to you, as the next step we take on this?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
