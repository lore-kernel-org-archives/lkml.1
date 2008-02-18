Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbYBRHN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbYBRHN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 02:13:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbYBRHNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 02:13:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:32839 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbYBRHNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 02:13:15 -0500
Date: Mon, 18 Feb 2008 08:12:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Dilger <adilger@sun.com>
Cc: Adrian Bunk <bunk@kernel.org>, sct@redhat.com, akpm@linux-foundation.org,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] fs/jbd/journal.c: cleanups
Message-ID: <20080218071229.GA1459@elte.hu>
References: <20080217081935.GN3848@cs181133002.pp.htv.fi> <20080218070439.GG3029@webber.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218070439.GG3029@webber.adilger.int>
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


* Andreas Dilger <adilger@sun.com> wrote:

> > This patch contains the following cleanups:
> > - make the following needlessly global function static:
> >   - journal_check_used_features()
> > - remove the following unused EXPORT_SYMBOL's:
> >   - journal_set_features
> >   - journal_update_superblock
> 
> Nack.  I don't object to un-exporting journal_update_superblock(), 
> because that is pretty internal, but the other functions are intended 
> specifically for use by code outside of JBD.  For example, the journal 
> checksum patch for ext3/4 uses journal_set_features() to turn on 
> features in the JBD superblock.
> 
> Similarly, for 64-bit support in ext4 uses journal_set_features() to 
> set a 64-bit feature flag in the journal superblock.

that's an invalid excuse for the benefit of out-of-tree forks: reality 
is that you can export those functions in the "journal checksum patch" 
just fine. So you cannot 'nack' a sensible patch on that ground and no 
maintainer does it on that ground. Once you get your stuff upstream, you 
can re-add the export.

	Ingo
