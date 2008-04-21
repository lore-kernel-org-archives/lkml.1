Return-Path: <linux-kernel-owner+w=401wt.eu-S1761782AbYDUNvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761782AbYDUNvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbYDUNvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:51:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56949 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761AbYDUNvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:51:06 -0400
Date: Mon, 21 Apr 2008 15:50:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [bug] SCSI/SLUB - latest -git: WARNING: at mm/slub.c:2443
	kmem_cache_destroy, scsi_put_host_cmd_pool()
Message-ID: <20080421135052.GL9554@elte.hu>
References: <20080419085758.GA18612@elte.hu> <Pine.LNX.4.64.0804191208430.25553@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0804202257120.13872@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804202257120.13872@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <clameter@sgi.com> wrote:

> On Sat, 19 Apr 2008, Pekka J Enberg wrote:
> 
> > > [a few .config options were turned off: just accept all the defaults 
> > >  after 'make oldconfig']
> > 
> > I couldn't spot anything in particular in SLUB which makes me think 
> > SCSI code simply didn't free all objects before 
> > scsi_put_host_cmd_pool() called kmem_cache_destroy() to kill the 
> > cache.
> > 
> > James, does this make sense or should I just look at SLUB harder?
> 
> The WARN is intended to warn that a kmem_cache_destroy was run with 
> objects not freed.

i suspect if that warn-on triggers more frequently then it might make 
sense to turn it into a pretty SLUB warning about that cache, with a 
stackdump at the end. (that way people are not tricked into mistakenly 
believing that it's a SLUB bug)

	Ingo
