Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbYGAHUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbYGAHUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 03:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbYGAHUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 03:20:31 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:35947 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbYGAHUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 03:20:30 -0400
Date: Tue, 1 Jul 2008 09:20:29 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: NeilBrown <neilb@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 001 of 29] md: Ensure interrupted recovery completed
 properly (v1 metadata plus bitmap)
In-Reply-To: <1080627064923.10270@suse.de>
Message-ID: <alpine.LNX.1.10.0807010918070.26892@fbirervta.pbzchgretzou.qr>
References: <20080627164503.9671.patches@notabene> <1080627064923.10270@suse.de>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-06-27 08:49, NeilBrown wrote:
>
>[...] In this case it tells recovery to ignore the bitmap
>and recovery all blocks.
>
>So without this fix, a raid1 ir raid4/5/6 array with version 1.x
>metadata and a write intent bitmaps, that is stopped in the middle
>of a recovery, will appear to complete the recovery instantly
>after it is reassembled, but the recovery will not be correct.

If the array is stopped in the middle of a recovery, should not
it restart recovery where it left off when reassembled?
That's what the write intent bitmap is for, is not it? Like..

wait_for(assemble)
for_all('1' bits in bitmap)
    if (resync == success)
        bitmap[pos] = '0';
    if (signalled)
        break;

and stopping the resync in the middle, the bitmap should still
have '1' bits left to be processed on the next assemble.
Or, where did I go wrong?
