Return-Path: <linux-kernel-owner+w=401wt.eu-S1758562AbZAQOEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562AbZAQOEA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 09:04:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbZAQODs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 09:03:48 -0500
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:46428 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751014AbZAQODr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 09:03:47 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] Allow SysRq emergency sync to thaw frozen filesystems
To: Eric Sandeen <sandeen@sandeen.net>, Valdis.Kletnieks@vt.edu,
       Eric Sandeen <sandeen@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       t-sato@yk.jp.nec.com
Reply-To: 7eggert@gmx.de
Date: Sat, 17 Jan 2009 15:03:39 +0100
References: <bUrIs-Za-3@gated-at.bofh.it> <bUKL7-6vo-3@gated-at.bofh.it> <bUNSJ-2Vn-13@gated-at.bofh.it> <bUO2t-376-5@gated-at.bofh.it> <bUYXL-3Qb-25@gated-at.bofh.it> <bUZ7p-448-9@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1LOBlz-0001tI-Oo@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen <sandeen@sandeen.net> wrote:
> Valdis.Kletnieks@vt.edu wrote:
>> On Thu, 15 Jan 2009 21:59:10 CST, Eric Sandeen said:

>>> Oh, actually, I'd think not.  If the freeze was done properly by the
>>> filesystem, all data was flushed, the fs was quiesced, and new IO was
>>> blocked.  pdflush should never be visiting these...
>> 
>> Yes, but a lot of 'if's - and usually you're reaching for sysrq-S precisely
>> *because* you suspect that stuff wasn't happening properly on its own...
> 
> Actually, only one if - if the fs implemented freeze properly.
> 
> Well, the use case I envision here is something like:
> 
> # freeze /my/mount/point/to/fs/to/snapshot
> 
> except oops, that wasn't mounted, and you just froze your root fs.

Maybe freeze should protect against that by requiring to specify the exact
mountpount, unless you say freeze --subdir?

