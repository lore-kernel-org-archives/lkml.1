Return-Path: <linux-kernel-owner+w=401wt.eu-S1753495AbYA0CSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbYA0CSW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 21:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbYA0CRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 21:17:15 -0500
Received: from ns1.suse.de ([195.135.220.2]:54324 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbYA0CRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 21:17:10 -0500
From: Andi Kleen <ak@suse.de>
Message-Id: <20080127317.043953000@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] [0/18] Implement some low hanging BKL removal fruit in fs/* 
Date: Sun, 27 Jan 2008 03:17:06 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[Andrew: I believe this is -mm material for .25]

- Convert some more file systems (generally those who don't use the BKL
for anything except mount) to use unlocked_bkl.
- Implement BKL less fasync (see patch for the rationale) 
This is currently a separate entry point, but since the number of fasync
users in the tree is relatively small I hope the older entry point can
be removed then in the not too far future
[help from other people converting more fasync users to unlocked_fasync
would be appreciated]
- Implement BKL less remote_llseek
- While I was at it I also added a few missing compat ioctl handlers
- Fix a few comments

This fixes a lot of relatively trivial BKL users in fs/*. The main 
remaining non legacy offenders are now locks.c, nfs/nfsd and reiserfs.
I believe BKL removal for all of those is being worked on by other people.
Also a lot of "legacy" file systems still use it, but converting those
does not seem to be very pressing.

-Andi
