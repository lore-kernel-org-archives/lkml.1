Return-Path: <linux-kernel-owner+w=401wt.eu-S1756969AbYGYDEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969AbYGYDEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 23:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484AbYGYDDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 23:03:45 -0400
Received: from homer.mvista.com ([63.81.120.158]:7918 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755458AbYGYDDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 23:03:44 -0400
Subject: Re: [PATCH 2/2[ Traffic control cgroups subsystem
From: Daniel Walker <dwalker@mvista.com>
To: Ranjit Manomohan <ranjitm@google.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, lizf@cn.fujitsu.com,
       menage@google.com, kaber@trash.net, akpm@linux-foundation.org
In-Reply-To: <Pine.LNX.4.64.0807241635460.30437@ranjit.corp.google.com>
References: <Pine.LNX.4.64.0807241635460.30437@ranjit.corp.google.com>
Content-Type: text/plain
Date: Thu, 24 Jul 2008 23:02:17 -0400
Message-Id: <1216954937.22487.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-24 at 16:37 -0700, Ranjit Manomohan wrote:


> +/* Delete one filter entry */
> +static int cgroup_delete(struct tcf_proto *tp, unsigned long arg)
> +{
> +	struct cgroup_head *head = (struct cgroup_head *) tp->root;
> +	struct cgroup_filter *t, *f = (struct cgroup_filter *) arg;
> +
> +	list_for_each_entry(t, &head->flist, link)
> +		if (t == f) {
> +			tcf_tree_lock(tp);
> +			list_del(&t->link);

Doesn't the above need to be a "_safe" list operation since your
deleting the element?

Daniel

