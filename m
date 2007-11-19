Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbXKSWhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbXKSWhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXKSWhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:37:00 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:38335 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbXKSWg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:36:59 -0500
Date: Mon, 19 Nov 2007 17:36:39 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Bastian Blank <bastian@waldi.eu.org>
cc: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       glommer@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, zach@vmware.com,
       jun.nakajima@intel.com
Subject: Re: [PATCH 7/24] consolidate msr.h
In-Reply-To: <20071119222151.GA11178@wavehammer.waldi.eu.org>
Message-ID: <Pine.LNX.4.58.0711191734270.32296@gandalf.stny.rr.com>
References: <11946337851964-git-send-email-gcosta@redhat.com>
 <11946337933104-git-send-email-gcosta@redhat.com>
 <11946337991750-git-send-email-gcosta@redhat.com>
 <11946338053158-git-send-email-gcosta@redhat.com>
 <11946338103068-git-send-email-gcosta@redhat.com> <1194633815833-git-send-email-gcosta@redhat.com>
 <11946338212915-git-send-email-gcosta@redhat.com>
 <11946338263902-git-send-email-gcosta@redhat.com> <20071119222151.GA11178@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 19 Nov 2007, Bastian Blank wrote:

> On Fri, Nov 09, 2007 at 04:42:48PM -0200, Glauber de Oliveira Costa wrote:
> > -	wrmsrl(MSR_CSTAR, ia32_cstar_target);
> > +	wrmsrl(MSR_CSTAR, (u64)ia32_cstar_target);
>
> Hmm, why do you add explicit casts? The compiler should convert that
> correctly on its own.
>
> > +static inline void wrmsrl(unsigned int msr, unsigned long long val)
>
> Hmm, long long is 64 bit on all x86, but why not use explicit u64 to
> show that?

(quick reply)

With PVOPS on it gives compiler warnings without that explict cast.
Without looking at the code, IIRC with non-PVOPS it is a macro directly
into asm, so it didn't matter what the cast was. But with PVOPS as a
function, it gave compiler warnings.

Take it out and try compiling it for both i386 and x86_64. One of them
gave warnings. But maybe it's not a problem now.

-- Steve

