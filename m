Return-Path: <linux-kernel-owner+w=401wt.eu-S1759051AbXKTKne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051AbXKTKne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 05:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220AbXKTKn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 05:43:26 -0500
Received: from ozlabs.org ([203.10.76.45]:52979 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198AbXKTKnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 05:43:25 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 7/24] consolidate msr.h
Date: Tue, 20 Nov 2007 21:43:12 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Ingo Molnar <mingo@elte.hu>, Bastian Blank <bastian@waldi.eu.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       glommer@gmail.com, tglx@linutronix.de, ak@suse.de, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, zach@vmware.com,
       jun.nakajima@intel.com
References: <11946337851964-git-send-email-gcosta@redhat.com> <20071120055113.GC20436@elte.hu> <Pine.LNX.4.58.0711200114580.4062@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0711200114580.4062@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711202143.13460.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 November 2007 17:16:45 Steven Rostedt wrote:
> On Tue, 20 Nov 2007, Ingo Molnar wrote:
> > i dont think there's ever any true need (and good cause) to force
> > integer type casts like that at the callee site.
>
> Unless you mean we should do something like this:
>
> static inline void __wrmsrl(unsigned int msr, unsigned long long val);
> #define wrmsr(msr, val) __wrmsrl(msr, (unsigned long long)var)

Heh:

union ptr_or_val {
	void *ptr;
	unsigned long long val;
};

static inline void __wrmsrl(unsigned int msr, union ptr_or_val pv);
#define wrmsr(msr, v) __wrmsrl(msr, (union ptr_or_val)v)

Ok, maybe not...
Rusty.
