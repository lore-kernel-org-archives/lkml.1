Return-Path: <linux-kernel-owner+w=401wt.eu-S1764983AbYART40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764983AbYART40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 14:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761968AbYART4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 14:56:19 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:49803 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761880AbYART4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 14:56:18 -0500
Date: Fri, 18 Jan 2008 20:56:17 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: travis@sgi.com
cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu, Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH 1/5] x86: Change size of node ids from u8 to u16 fixup
In-Reply-To: <20080118183011.527888000@sgi.com>
Message-ID: <Pine.LNX.4.64.0801182055190.15604@fbirervta.pbzchgretzou.qr>
References: <20080118183011.354965000@sgi.com> <20080118183011.527888000@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 18 2008 10:30, travis@sgi.com wrote:
>--- a/include/linux/numa.h
>+++ b/include/linux/numa.h
>@@ -10,4 +10,10 @@
> 
> #define MAX_NUMNODES    (1 << NODES_SHIFT)
> 
>+#if MAX_NUMNODES > 256
>+typedef u16 numanode_t;
>+#else
>+typedef u8 numanode_t;
>+#endif
>+

Do we really need numanode_t in userspace? I'd rather not, especially
when its type is dependent on MAX_NUMNODES. Wrap with #ifdef __KERNEL__.
