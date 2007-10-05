Return-Path: <linux-kernel-owner+w=401wt.eu-S1761096AbXJERgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761096AbXJERgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 13:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756929AbXJERgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 13:36:45 -0400
Received: from pat.uio.no ([129.240.10.15]:33060 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763AbXJERgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 13:36:44 -0400
Subject: Re: [NFS] What's slated for inclusion in 2.6.24-rc1 from the NFS
	client git tree...
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Peter Staubach <staubach@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, nfsv4@linux-nfs.org,
       nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20071005082513.4b5a058c@poseidon.drzeus.cx>
References: <1191454876.6726.32.camel@heimdal.trondhjem.org>
	 <20071004085206.0a8e37b5@poseidon.drzeus.cx>
	 <1191506450.6685.17.camel@heimdal.trondhjem.org>
	 <20071004184304.6e71ab6d@poseidon.drzeus.cx>
	 <20071004114243.3161af16.akpm@linux-foundation.org>
	 <1191525363.6739.12.camel@heimdal.trondhjem.org>
	 <47054205.8000908@redhat.com>  <20071005082513.4b5a058c@poseidon.drzeus.cx>
Content-Type: text/plain
Date: Fri, 05 Oct 2007 13:36:19 -0400
Message-Id: <1191605779.6715.86.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, AWL=0.025)
X-UiO-Scanned: 004ACC211ADEE74B59C78091759423ECB2C28CF6
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 330 total 4316799 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-05 at 08:25 +0200, Pierre Ossman wrote:

> Print a warning or something so that they can be found. Don't go
> breaking systems left and right. People have better things to do than
> to fix the build systems for ever program they use.

The kernel knows bugger all about what glibc function your program is
calling. The problem here is precisely that newer versions of glibc will
transform legacy 32-bit stat() calls into 64-bit stat64() calls, then
will complain when the result overflows.

If you want to figure out which apps are broken, then you will have to
either do so in glibc or use a preloaded shared library to intercept the
32-bit stat() calls and print out a warning.

Trond

