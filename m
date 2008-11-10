Return-Path: <linux-kernel-owner+w=401wt.eu-S1755156AbYKJSXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbYKJSXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 13:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbYKJSXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 13:23:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49591 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbYKJSXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 13:23:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: CONFIG_NUMA breaks hibernation on x86-32 with PAE
Date: Mon, 10 Nov 2008 19:28:03 +0100
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <20081109140726.GB1786@ucw.cz> <20081110080436.GF2093@elte.hu> <87hc6fpwof.fsf@basil.nowhere.org>
In-Reply-To: <87hc6fpwof.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811101928.04565.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 10 of November 2008, Andi Kleen wrote:
> Ingo Molnar <mingo@elte.hu> writes:
> >
> > No good ideas - the bug description gives me the impression of memory 
> > maps save/restore hickup in the hibernation code - and memory maps are 
> > pretty much the only thing that are significantly different on NUMA. 
> 
> I assume the problem happened on a single node system.
> On single node the memory map should be actually quite similar
> to the UMA case.

It is.  However, the problem is 100% reproducible on any 32-bit single-node
system with CONFIG_NUMA set, from what I can tell.

It doesn't happen if the kernel is booted with highmem=0, so it looks like
the code that saves highmem causes the problem to happen.  However, this
same code works well for all of the !CONFIG_NUMA cases and practically only
the only non-open-coded it uses is kmap_atomic().

> One possibility would be to bisect if it ever worked?

Not sure it did, probably not. :-(

BTW, can you please tell me why HIGHMEM64G is requisite for NUMA on 32-bit?

Thanks,
Rafael
