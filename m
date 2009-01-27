Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbZA0Qxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbZA0Qxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 11:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbZA0QxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 11:53:23 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45722 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754757AbZA0QxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 11:53:23 -0500
Subject: Re: [PATCH 1/2 #tj-percpu] x86: fix build breakage on voyage
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Brian Gerst <brgerst@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Tejun Heo <htejun@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <73c1f2160901270825y5e7f3974m830c399074c2e8f1@mail.gmail.com>
References: <20090126103243.GA31307@elte.hu>
	 <20090126141832.GA31442@elte.hu> <497E6B34.1020508@kernel.org>
	 <497E8778.9060503@gmail.com>
	 <1233032609.3248.78.camel@localhost.localdomain>
	 <497E9B9D.4010102@gmail.com> <20090127113734.GA28249@elte.hu>
	 <1233070302.3231.34.camel@localhost.localdomain>
	 <20090127155044.GB28209@elte.hu>
	 <1233072253.3231.47.camel@localhost.localdomain>
	 <73c1f2160901270825y5e7f3974m830c399074c2e8f1@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 27 Jan 2009 16:53:21 +0000
Message-Id: <1233075201.3231.59.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-27 at 11:25 -0500, Brian Gerst wrote:
> To be fair, setup_percpu.c isn't built on UP.  But we're splitting
> hairs over just 3 conditional variables.  I'm open to ideas, but I'm
> quite certain that any general solution will have more overhead than
> the current code.  I am looking at a patch to remove the early percpu
> pointers, so the second set of ifdefs would go away.

Well, how much do you need rid of?  All the local apic stuff can move
into apic.c as something like x86_percpu_apic_setup(cpu) for the in loop
stuff and x86_percpu_apic_global() for the rest ... these then become
weak empty functions in setup_percpu.c.  That elimiates the alleged
voyager problem.

The other cases are nastier:  there's a numa case, an x86_84 case and a
both numa and x86_64 case.  We only have files for the x86_64 case.  At
a stretch the numa cases could move into mm/numa_${BITS}.c

This isn't really hugely critical path so this type of approach would
work ... I can cook up a patch if it's acceptable? 

James


