Return-Path: <linux-kernel-owner+w=401wt.eu-S1759996AbZCTTOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759996AbZCTTOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 15:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760057AbZCTTOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 15:14:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45395 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760305AbZCTTOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 15:14:21 -0400
Date: Fri, 20 Mar 2009 19:14:07 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Christopher Li <sparse@chrisli.org>, linux-sparse@vger.kernel.org,
       Hannes Eder <hannes@hanneseder.net>, linux-kernel@vger.kernel.org
Subject: Re: Nasal demons in preprocessor use (Re: [PATCH] test-suite: new
	preprocessor test case)
Message-ID: <20090320191407.GI28946@ZenIV.linux.org.uk>
References: <20090319175544.13691.42362.stgit@f10box.hanneseder.net> <20090319182628.GB28946@ZenIV.linux.org.uk> <154e089b0903191151q37ab7b20o43838845af12966f@mail.gmail.com> <20090319190730.GC28946@ZenIV.linux.org.uk> <20090319192758.GB24318@elte.hu> <19f34abd0903191320qdd73530ud85081d23e17b266@mail.gmail.com> <20090320180853.GA24154@elte.hu> <20090320190409.GH28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090320190409.GH28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 07:04:09PM +0000, Al Viro wrote:
> On Fri, Mar 20, 2009 at 07:08:53PM +0100, Ingo Molnar wrote:
> > 
> > * Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > 
> > > I guess this means that kmemcheck branch should be withdrawn from 
> > > linux-next, at least temporarily, as I have no immediate 
> > > workarounds/alternatives. Stephen, can you drop it?
> > 
> > Al Viro, well done :-(
> > 
> > 	Ingo
> 
> What the fuck?

While we are at it, there *is* an obvious workaround:
#ifdef ...
	#define L1 <list>
#else
	#define L1
#endif
#ifdef ...
	#define L2 <list>
#else
	#define L2
#endif
	your_macro(...
	L1
	L2
	...)
#undef L1
#undef L2

Ingo, care to explain what the hell had your reply above been about?
Especially since we both apparently agree that code in question did
need fixing, what with your immediate ACK upthread...
