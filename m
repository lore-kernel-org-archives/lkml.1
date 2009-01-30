Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbZA3JGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbZA3JGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 04:06:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbZA3JFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 04:05:11 -0500
Received: from tundra.namei.org ([65.99.196.166]:4800 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbZA3JFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 04:05:08 -0500
Date: Fri, 30 Jan 2009 20:04:54 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       "<David Safford" <safford@watson.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 2/6] integrity: IMA as an integrity service provider
In-Reply-To: <eae67eb66b76df32f0e95c4cda33fd6271567c94.1233262163.git.zohar@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.1.10.0901302003370.31987@tundra.namei.org>
References: <cover.1233262162.git.zohar@linux.vnet.ibm.com> <eae67eb66b76df32f0e95c4cda33fd6271567c94.1233262163.git.zohar@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009, Mimi Zohar wrote:

> +static struct ima_queue_entry *ima_lookup_digest_entry(u8 *digest_value)
> +{
> +	struct ima_queue_entry *qe, *ret = NULL;
> +	unsigned int key;
> +	struct hlist_node *pos;
> +
> +	key = ima_hash_key(digest_value);
> +	rcu_read_lock();
> +	hlist_for_each_entry_rcu(qe, pos, &ima_htable.queue[key], hnext) {
> +		if (memcmp(qe->entry->digest, digest_value, 20) == 0) {

Minor issue: '20' should be IMA_DIGEST_SIZE, right?


- James
-- 
James Morris
<jmorris@namei.org>
