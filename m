Return-Path: <linux-kernel-owner+w=401wt.eu-S1764133AbXF1DDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764133AbXF1DDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 23:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763209AbXF1DDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 23:03:31 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2487 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763622AbXF1DDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 23:03:30 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 27 Jun 2007 20:03:26 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Eric Dumazet <dada1@cosmosbay.com>,
       Chuck Ebbert <cebbert@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jarek Poplawski <jarkao2@o2.pl>, Miklos Szeredi <miklos@szeredi.hu>,
       chris@atlee.ca,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] long freezes on thinkpad t60
In-Reply-To: <alpine.LFD.0.98.0706271725050.8675@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706271958340.5213@alien.or.mcafeemobile.com>
References: <20070620093612.GA1626@ff.dom.local>
 <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org>
 <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org>
 <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com>
 <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org>
 <20070621202917.a2bfbfc7.dada1@cosmosbay.com>
 <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org>
 <4680D162.9050603@yahoo.com.au> <alpine.LFD.0.98.0706261016200.8675@woody.linux-foundation.org>
 <4681F448.3040201@yahoo.com.au> <alpine.LFD.0.98.0706262249590.8675@woody.linux-foundation.org>
 <alpine.LFD.0.98.0706271233300.8675@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706271310550.5219@alien.or.mcafeemobile.com>
 <alpine.LFD.0.98.0706271500260.8675@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706271545490.3879@alien.or.mcafeemobile.com>
 <alpine.LFD.0.98.0706271725050.8675@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007, Linus Torvalds wrote:

> On Wed, 27 Jun 2007, Davide Libenzi wrote:
> 
> > On Wed, 27 Jun 2007, Linus Torvalds wrote:
> > > 
> > > Stores never "leak up". They only ever leak down (ie past subsequent loads 
> > > or stores), so you don't need to worry about them. That's actually already 
> > > documented (although not in those terms), and if it wasn't true, then we 
> > > couldn't do the spin unlock with just a regular store anyway.
> > 
> > Yes, Intel has never done that. They'll probably never do it since it'll 
> > break a lot of system software (unless they use a new mode-bit that 
> > allows system software to enable lose-ordering). Although I clearly 
> > remember to have read in one of their P4 optimization manuals to not 
> > assume this in the future.
> 
> That optimization manual was confused. 
> 
> The Intel memory ordering documentation *clearly* states that only reads 
> pass writes, not the other way around.

Yes, they were stating that clearly. IIWNOC (If I Were Not On Crack) I 
remember them saying to not assume any ordering besides the data 
dependency and the CPU self-consistency in the future CPUs, and to use 
*fence instructions when certain semantics were required.
But google did not help me in finding that doc, so maybe I were really on 
crack :)



- Davide


