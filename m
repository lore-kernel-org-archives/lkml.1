Return-Path: <linux-kernel-owner+w=401wt.eu-S965042AbXHLPv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965042AbXHLPv3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757802AbXHLPvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:51:20 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:34808 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbXHLPvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:51:19 -0400
Date: Sun, 12 Aug 2007 17:51:18 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>, mingo@redhat.com
Subject: Re: [patch 01/23] Fall back on interrupt disable in cmpxchg8b on
 80386 and 80486
In-Reply-To: <20070812145834.542290892@polymtl.ca>
Message-ID: <Pine.LNX.4.64.0708121750090.28963@fbirervta.pbzchgretzou.qr>
References: <20070812145434.520271946@polymtl.ca> <20070812145834.542290892@polymtl.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 12 2007 10:54, Mathieu Desnoyers wrote:

>Date: Sun, 12 Aug 2007 10:54:35 -0400
>From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
>To:  <akpm@linux-foundation.org>,  <linux-kernel@vger.kernel.org>
>Cc: Christoph Lameter <clameter@sgi.com>,
>    Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,  <mingo@redhat.com>
>Subject: [patch 01/23] Fall back on interrupt disable in cmpxchg8b on 80386 and
>     80486
>
>Actually, on 386, cmpxchg and cmpxchg_local fall back on
>cmpxchg_386_u8/16/32: it disables interruptions around non atomic
>updates to mimic the cmpxchg behavior.
>
>The comment:
>/* Poor man's cmpxchg for 386. Unsuitable for SMP */
>
>already present in cmpxchg_386_u32 tells much about how this cmpxchg
>implementation should not be used in a SMP context. However, the cmpxchg_local
>can perfectly use this fallback, since it only needs to be atomic wrt the local
>cpu.
>
>This patch adds a cmpxchg_486_u64 and uses it as a fallback for cmpxchg64
>and cmpxchg64_local on 80386 and 80486.

hm, but why is it called cmpxchg_486 when the other functions are called
cmpxchg_386?


	Jan
-- 
