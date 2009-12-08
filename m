Return-Path: <linux-kernel-owner+w=401wt.eu-S965853AbZLHTZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965853AbZLHTZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 14:25:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965837AbZLHTZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 14:25:04 -0500
Received: from tomts5.bellnexxia.net ([209.226.175.25]:56606 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965833AbZLHTZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 14:25:03 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao4FAGcyHkuuWOw8/2dsb2JhbACBTNgahDIE
Date: Tue, 8 Dec 2009 14:20:06 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>,
       Robert Olsson <robert.olsson@its.uu.se>,
       Jens Laas <jens.laas@data.slu.se>, Hans Liss <hans.liss@its.uu.se>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fib-trie: code cleanup
Message-ID: <20091208192006.GC1653@Krystal>
References: <20091208184839.GA31383@Krystal> <20091208110642.1dbb53cd@nehalam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091208110642.1dbb53cd@nehalam>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 14:17:58 up 6 days, 10:08,  4 users,  load average: 0.35, 0.18,
	0.11
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Hemminger (shemminger@linux-foundation.org) wrote:
> On Tue, 8 Dec 2009 13:48:39 -0500
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > -	while ( (tb_node = rcu_dereference(tb->tb_hlist.next)) ) {
> > +	while ((tb_node = rcu_dereference(tb->tb_hlist.next))) {
> >  
> 
> This is clearer before with the added whitespace, ignore checkpatch natterings.

OK

Then we should do the same for all assignment within while() :

static void tnode_free_flush(void)
{
        struct tnode *tn;

        while ( (tn = tnode_free_head) ) {

...

static struct leaf *leaf_walk_rcu(struct tnode *p, struct node *c)
{
.....
               /* Node empty, walk back up to parent */
                c = (struct node *) p;
        } while ( (p = node_parent_rcu(c)) != NULL);

        return NULL; /* Root of trie */
}


> 
> -- 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
