Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbYIVQfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbYIVQfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 12:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbYIVQf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 12:35:29 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:41825 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbYIVQf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 12:35:28 -0400
Subject: Re: [NFS] blocks of zeros (NULLs) in NFS files in kernels >= 2.6.20
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: linux-kernel@vger.kernel.org, Aaron Straus <aaron@merfinllc.com>,
       Chuck Lever <chuck.lever@oracle.com>, Neil Brown <neilb@suse.de>,
       Linux NFS Mailing List <linux-nfs@vger.kernel.org>
In-Reply-To: <200809221805.48463.hpj@urpla.net>
References: <20080905191939.GG22796@merfinllc.com>
	 <56258A29-95D5-4A8C-A097-014B8FEDFB8F@oracle.com>
	 <20080911184951.GB19054@merfinllc.com>  <200809221805.48463.hpj@urpla.net>
Content-Type: text/plain
Date: Mon, 22 Sep 2008 12:35:22 -0400
Message-Id: <1222101322.7615.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, MISSING_SUBJECT=0.001,NO_RECEIVED=-0.001, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 243BCAEF129B20CCB8FB0FBDDD3E5A47E2277940
X-UiO-SPAM-Test: remote_host: 68.40.183.129 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 1 total 37 max/h 3 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-22 at 18:05 +0200, Hans-Peter Jansen wrote:
> For what is worth, this behavior is visible in bog standard writing/reading 
> files, (log files in my case, via the python logging package). It obviously 
> deviates from local filesystem behavior, and former state of the linux 
> nfs-client. Should we add patches to less, tail, and all other instruments 
> for watching/analysing log files (just to pick the tip of the ice rock) in 
> order to throw away runs of zeros, when reading from nfs mounted files? Or 
> should we ask their maintainers to add locking code for the nfs "read 
> files, which are written at the same time" case, just to work around 
> __some__ of the consequences of this bug? Imagine, how ugly this is going 
> to look! 
> 
> The whole issue is what I call a major regression, thus I strongly ask for a 
> reply from Trond on this matter.
> 
> I even vote for sending a revert request for this hunk to the stable team, 
> where it is applicable, after Trond sorted it out (for 2.6.27?).
> 
> Thanks, Aaron and Chuck for the detailed analysis - it demystified a wired 
> behavior, I observed here. When you're in a process to get real work done 
> in a fixed timeline, such things could make you mad..

Revert _what_ exactly?

Please assume that I've been travelling for the past 5 weeks, and have
only a sketchy idea of what has been going on.
My understanding was that this is a consequence of unordered writes
causing the file to be extended while some other task is reading.
AFAICS, this sort of behaviour has _always_ been possible. I can't see
how reverting anything will fix it.

  Trond

