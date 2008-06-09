Return-Path: <linux-kernel-owner+w=401wt.eu-S1761727AbYFIOXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761727AbYFIOXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 10:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758520AbYFIOTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 10:19:18 -0400
Received: from relay2.sgi.com ([192.48.171.30]:56100 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754507AbYFIOTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 10:19:17 -0400
Date: Mon, 9 Jun 2008 07:19:16 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Andrew Morton <akpm@linux-foundation.org>, kosaki.motohiro@jp.fujitsu.com,
       nickpiggin@yahoo.com.au, hugh@veritas.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vmallocinfo: Add NUMA informations
In-Reply-To: <4846AE30.8000302@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0806090717370.29723@schroedinger.engr.sgi.com>
References: <48439916.2070108@cosmosbay.com> <20080602160548.B6D4.KOSAKI.MOTOHIRO@jp.fujitsu.com>
 <4844BC75.8040705@cosmosbay.com> <20080603144054.973284bb.akpm@linux-foundation.org>
 <4846AE30.8000302@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008, Eric Dumazet wrote:

> -	return seq_open(file, &vmalloc_op);
> +	unsigned int *ptr = NULL;
> +	int ret;
> +
> +	if (NUMA_BUILD)
> +		ptr = kmalloc(nr_node_ids * sizeof(unsigned int), GFP_KERNEL);

Maybe a bit of overkill here. nr_node_ids == 1 in the !NUMA case which 
should not do much harm if you alloc the struct anymore.

