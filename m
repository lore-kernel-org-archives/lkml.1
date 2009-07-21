Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955AbZGULFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbZGULFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 07:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbZGULFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 07:05:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51119 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbZGULFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 07:05:05 -0400
Date: Tue, 21 Jul 2009 13:04:58 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, norsk5@yahoo.com, aris@redhat.com,
       linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 07/14] mce3: pass mce info to EDAC for decoding
Message-ID: <20090721110458.GB29028@basil.fritz.box>
References: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com> <1248106385-27514-8-git-send-email-borislav.petkov@amd.com> <20090720180446.GB16072@basil.fritz.box> <20090721104443.GC32338@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090721104443.GC32338@aftab>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 12:44:43PM +0200, Borislav Petkov wrote:
> On Mon, Jul 20, 2009 at 08:04:46PM +0200, Andi Kleen wrote:
> > On Mon, Jul 20, 2009 at 06:12:58PM +0200, Borislav Petkov wrote:
> > > Use a weakly defined symbol instead of ugly ifdefs.
> > 
> > I'm not sure what you're trying to archive, but if you're
> > trying to catch corrected MCs you're hooking into the 
> > wrong function. print_mce is only called for PCC=1.
> 
> Well, I was able to mce-inject a PCC=0 MCE with UC set:

Try it without UC=1. 

> 
> > Also if you're checking for specific banks you
> > need to check for vendor/cpu model first of course.
> > In your current implementation e.g. a Intel CPU
> > would pass some random event into your AMD specific code,
> > which is probably not intended and might even crash.
> 
> Actually I wanted to worry about that only after we have more than one
> vendor-specific MCE decoders :).

But your code is always unconditionally called when the code
is linked in.  I suspect i'll just crash on systems
where amd64_edac is not initialized.

> > It would be probably cleaner if you defined a standard
> > notifier chain interface.
> 
> Sounds like a cleaner solution, at a first glance. Will look into it.

Actually on second though a notifier chain is a bad idea
because there is too much risk having bad modules mess
up machine check handling. It's a critical path like
oops handling.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
