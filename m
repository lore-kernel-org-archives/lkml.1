Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbZA3NNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbZA3NNe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 08:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbZA3NN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 08:13:26 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40531 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbZA3NNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 08:13:25 -0500
Subject: Re: [PATCH 2/6] integrity: IMA as an integrity service provider
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       "<David Safford" <safford@watson.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <alpine.LRH.1.10.0901302003370.31987@tundra.namei.org>
References: <cover.1233262162.git.zohar@linux.vnet.ibm.com>
	 <eae67eb66b76df32f0e95c4cda33fd6271567c94.1233262163.git.zohar@linux.vnet.ibm.com>
	 <alpine.LRH.1.10.0901302003370.31987@tundra.namei.org>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 08:13:22 -0500
Message-Id: <1233321202.3602.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-30 at 20:04 +1100, James Morris wrote:
> On Thu, 29 Jan 2009, Mimi Zohar wrote:
> 
> > +static struct ima_queue_entry *ima_lookup_digest_entry(u8 *digest_value)
> > +{
> > +	struct ima_queue_entry *qe, *ret = NULL;
> > +	unsigned int key;
> > +	struct hlist_node *pos;
> > +
> > +	key = ima_hash_key(digest_value);
> > +	rcu_read_lock();
> > +	hlist_for_each_entry_rcu(qe, pos, &ima_htable.queue[key], hnext) {
> > +		if (memcmp(qe->entry->digest, digest_value, 20) == 0) {
> 
> Minor issue: '20' should be IMA_DIGEST_SIZE, right?
> 
> 
> - James

Right.

Mimi

