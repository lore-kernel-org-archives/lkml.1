Return-Path: <linux-kernel-owner+w=401wt.eu-S1758638AbXLLUDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbXLLUDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 15:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbXLLUDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 15:03:32 -0500
Received: from pat.uio.no ([129.240.10.15]:58455 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbXLLUDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 15:03:31 -0500
Subject: Re: [PATCH 1/1] fix 2.6.24-rc1 nfs_file_mmap change for NOMMU
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: "Berkhan, Enrik (GE Infra, Oil & Gas)" <enrik.berkhan@ge.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <050A770C1DB41144817F02E395E493105257D4@FLRMLVEM02.e2k.ad.ge.com>
References: <050A770C1DB41144817F02E395E493104CE014@FLRMLVEM02.e2k.ad.ge.com>
	 <1197427230.27750.3.camel@heimdal.trondhjem.org>
	 <050A770C1DB41144817F02E395E493105257D4@FLRMLVEM02.e2k.ad.ge.com>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 15:03:24 -0500
Message-Id: <1197489804.9042.9.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.8, required=5.0, autolearn=disabled, AWL=-0.824)
X-UiO-Scanned: ED92D5D1AB227CAC6A589A62EAC1C62BCBF50B84
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -7 maxlevel 200 minaction 2 bait 0 mail/h: 44 total 5713250 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-12-12 at 08:29 +0100, Berkhan, Enrik (GE Infra, Oil & Gas)
wrote:
> Trond Myklebust wrote:
> > On Sun, 2007-12-09 at 19:52 +0100, Berkhan, Enrik (GE Infra, Oil & Gas)
> > wrote:
> >> - generic_file_mmap returns -ENOSYS for NOMMU systems; replicate this  
> >> behaviour 
> > 
> > Why do that after going through the process of revalidating the inode
> > etc.? Just replace nfs_file_mmap() with a function returning ENOSYS in
> > the case of CONFIG_MMU.
> > 
> > Better still, in the case of CONFIG_MMU, instead of having an
> > nfs_file_mmap(), just replace the .mmap field in nfs_file_operations
> > with a call to generic_file_mmap().
> 
> I just tried to make it work without really knowing what I do :)
> 
> I have mailed another patch implementing your second suggestion (the system
> still boots with nfsroot).

Thanks. That patch looks better. I have 2 questions, though:

     1. Is this urgent enough to warrant pushing into 2.6.24?
     2. Are there any filesystems which support mmap() on !CONFIG_MMU?

Cheers
  Trond

