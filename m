Return-Path: <linux-kernel-owner+w=401wt.eu-S933150AbZJLTTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150AbZJLTTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 15:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933084AbZJLTTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 15:19:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757518AbZJLTSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 15:18:32 -0400
Date: Mon, 12 Oct 2009 16:17:53 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH][retry 3] Support Pause Filter in AMD processors
Message-ID: <20091012191753.GA13967@amt.cnet>
References: <200910021449.59284.mark.langsdorf@amd.com> <200910061425.03191.mark.langsdorf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910061425.03191.mark.langsdorf@amd.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 02:25:02PM -0500, Mark Langsdorf wrote:
> >From 8ec340648103510095ff339b914706c81e9d815d Mon Sep 17 00:00:00 2001
> From: Mark Langsdorf <mark.langsdorf@amd.com>
> Date: Wed, 9 Sep 2009 22:12:51 -0500
> Subject: [PATCH] [PATCH] Support Pause Filter in AMD processors
> 
> New AMD processors (Family 0x10 models 8+) support the Pause
> Filter Feature.  This feature creates a new field in the VMCB
> called Pause Filter Count.  If Pause Filter Count is greater
> than 0 and intercepting PAUSEs is enabled, the processor will
> increment an internal counter when a PAUSE instruction occurs
> instead of intercepting.  When the internal counter reaches the
> Pause Filter Count value, a PAUSE intercept will occur.
> 
> This feature can be used to detect contended spinlocks,
> especially when the lock holding VCPU is not scheduled.
> Rescheduling another VCPU prevents the VCPU seeking the
> lock from wasting its quantum by spinning idly.
> 
> Experimental results show that most spinlocks are held
> for less than 1000 PAUSE cycles or more than a few
> thousand.  Default the Pause Filter Counter to 3000 to
> detect the contended spinlocks.
> 
> Processor support for this feature is indicated by a CPUID
> bit.
> 
> On a 24 core system running 4 guests each with 16 VCPUs,
> this patch improved overall performance of each guest's
> 32 job kernbench by approximately 3-5% when combined
> with a scheduler algorithm thati caused the VCPU to
> sleep for a brief period. Further performance improvement
> may be possible with a more sophisticated yield algorithm.
> 
> This patch depends on the changes to the kvm code from
> "KVM:VMX: Add support for Pause Loop Exiting"
> http://www.mail-archive.com/kvm@vger.kernel.org/msg23089.html
> 
> -Mark Langsdorf
> Operating System Research Center
> AMD
> 
> Signed-of-by: Mark Langsdorf <mark.langsdorf@amd.com>

Applied, thanks.

