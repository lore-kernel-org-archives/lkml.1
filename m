Return-Path: <linux-kernel-owner+w=401wt.eu-S1752766AbYKURLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbYKURLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:11:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754525AbYKURLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:11:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59191 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318AbYKURLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:11:17 -0500
Date: Fri, 21 Nov 2008 18:10:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 06/10] x86: add check code for map/unmap_sg code
Message-ID: <20081121171055.GJ733@elte.hu>
References: <1227284770-19215-1-git-send-email-joerg.roedel@amd.com> <1227284770-19215-7-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227284770-19215-7-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> +	ret =  ops->map_sg(hwdev, sg, nents, direction);

stray double space in '=  ops'.

another very small detail:

> +	unsigned long flags;
> +	struct dma_debug_entry *entry;
> +	struct scatterlist *s;
> +	int i;

please order them like this, similar to the include line:

> +	struct dma_debug_entry *entry;
> +	struct scatterlist *s;
> +	unsigned long flags;
> +	int i;

that makes the whole variable section non-intrusive. (and also acts as 
a patch-conflict-reducer mechanism in the future - when variable 
definition lines get particularly long)

(not a hard rule, exceptions are possible - grouping same-type fields 
together, etc.)

	Ingo
