Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbXKKAig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbXKKAig (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 19:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755822AbXKKAi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 19:38:28 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:47943 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810AbXKKAi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 19:38:28 -0500
Date: Sun, 11 Nov 2007 01:38:27 +0100 (CET)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       WU Fengguang <wfg@mail.ustc.edu.cn>, Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Temporary lockup on loopback block device
In-Reply-To: <1194735752.5828.1.camel@lappy>
Message-ID: <Pine.LNX.4.64.0711110135450.18189@artax.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0711102025440.17691@artax.karlin.mff.cuni.cz> 
 <20071110145444.a6993df1.akpm@linux-foundation.org> <1194735752.5828.1.camel@lappy>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Arguably we just have the wrong backing-device here, and what we should do
> > is to propagate the real backing device's pointer through up into the
> > filesystem.  There's machinery for this which things like DM stacks use.
> > 
> > I wonder if the post-2.6.23 changes happened to make this problem go away.
> 
> The per BDI dirty stuff in 24 should make this work, I just checked and
> loopback thingies seem to have their own BDI, so all should be well.

This is not only about loopback (I think the lockup can happen even 
without loopback) --- the main problem is:

Why are there over-limit dirty pages that no one is writing?

Mikulas
