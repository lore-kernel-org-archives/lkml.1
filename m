Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbYJaPSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbYJaPSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 11:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbYJaPSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 11:18:09 -0400
Received: from mail.tpi.com ([198.107.51.143]:1605 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbYJaPSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 11:18:08 -0400
Message-ID: <490B21AE.9030406@tpi.com>
Date: Fri, 31 Oct 2008 09:18:06 -0600
From: Tim Gardner <tcanonical@tpi.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] B+Tree library
References: <20081026124643.GA1328@logfs.org> <1225458974.5546.6.camel@johannes.berg>
In-Reply-To: <1225458974.5546.6.camel@johannes.berg>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg wrote:
>> +static inline size_t btree_visitorl(struct btree_headl *head, long opaque,
>> +		visitorl_t func2)
>> +{
>> +	return btree_visitor(&head->h, &btree_geo32, opaque, visitorl, func2);
>> +}
> 
> Incidentally, do you think it would be possible to implement a kind of 
> 
> btree_for_each_entry(e, ...) {
> 	do something with e
> }
> 
> macro or function/macro combination? You seem to be doing a recursive
> walk across the tree, would it be useful to have a linked list at the
> lowest level of nodes to be able to iterate more easily?
> 
> johannes

What would you expect to be the behavior if you remove 'e' ? That might
cause the tree to get re-ordered. Do you restart the list traversal?

I had a similar issue once with a hash table algorithm where you could
either access elements with a hash key, or efficiently traverse the hash
table using a linked list of elements. The solution wasn't too difficult
in that case because removing an element didn't cause the table to get
re-ordered.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
