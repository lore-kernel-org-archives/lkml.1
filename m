Return-Path: <linux-kernel-owner+w=401wt.eu-S1754101AbZJKPU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbZJKPU4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 11:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbZJKPUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 11:20:54 -0400
Received: from vena.lwn.net ([206.168.112.25]:43640 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbZJKPUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 11:20:54 -0400
Date: Sun, 11 Oct 2009 09:20:15 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: John Kacur <jkacur@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vincent^M^J Sanders <vince@simtec.co.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sound_core.c: Remove BKL from soundcore_open
Message-ID: <20091011092015.37a69847@bike.lwn.net>
In-Reply-To: <alpine.LFD.2.00.0910110223510.4921@localhost.localdomain>
References: <alpine.LFD.2.00.0910110123510.4921@localhost.localdomain>
	<20091011004219.74c30f67@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.0910110223510.4921@localhost.localdomain>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Oct 2009 02:25:53 +0200 (CEST)
John Kacur <jkacur@redhat.com> wrote:

> Yikes, I missed that. Still I'm loath to just push it down like that. I 
> wonder if I can use a mutex there. What about the following patch?

Unfortunately, it's often not quite that simple.  What if, say, there's
an ioctl() function somewhere which is depending on the BKL for
exclusion here?  This change would then introduce races.  Changing the
BKL to a mutex is a real semantic change which requires a real survey
of the code affected.

That's why the pushdown approach has been taken so often.  It's a pain,
but it eventually shines a spotlight on every bit of affected code.

jon
