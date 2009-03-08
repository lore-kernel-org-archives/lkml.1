Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbZCHQyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbZCHQyD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 12:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbZCHQxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 12:53:52 -0400
Received: from smtp-out.google.com ([216.239.45.13]:24357 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbZCHQxv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 12:53:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=ny/IWXORbiN2sVbwoQUlAkKm+8TeYlTJTSbVpODxo2o453Sl6VCJ7LXVzOZ1zxUN9
	IOndEGbcArTAjB1QPwv+g==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0903080917460.25207@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903080917460.25207@chino.kir.corp.google.com>
Date: Sun, 8 Mar 2009 09:53:44 -0700
Message-ID: <6599ad830903080953na692dcfh7f455bfe46a895c3@mail.gmail.com>
Subject: Re: [patch -mm] cpusets: add memory_slab_hardwall flag
From: Paul Menage <menage@google.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 8, 2009 at 9:27 AM, David Rientjes <rientjes@google.com> wrote:
> +/**
> + * current_cpuset_object_allowed - can a slab object be allocated on a node?
> + * @node: the node for object allocation
> + * @flags: allocation flags
> + *
> + * Return non-zero if object is allowed, zero otherwise.
> + */
> +int current_cpuset_object_allowed(int node, gfp_t flags)
> +{
> +       return !is_slab_hardwall(task_cs(current)) ||
> +              cpuset_node_allowed_hardwall(node, flags);
> +}
> +

This should be in rcu_read_lock()/rcu_read_unlock() in order to safely
dereference the result of task_cs(current)

I'll leave the actual memory allocator changes for others to comment on .

Paul
