Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbZCDMBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbZCDMBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 07:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbZCDMBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 07:01:06 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:48884 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbZCDMA6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 07:00:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pavwZxCu3Ak7YDAavcGJ1yW0BcP/3C7WEYWhD4U2YKqxw0mQCbyXKO6wwWRDuupWuF
         vqnvmlwbpl/w4eV5h1BdvU7SY/HwmlPrVRkOQlH5nX3mR4rrPihzXf6sTBhtM/kfYSxt
         FqAQLRP3dG4aIKtNrZ8/BrI+J5haJluA5fBn0=
MIME-Version: 1.0
In-Reply-To: <20090304114504.GB4916@elte.hu>
References: <49AD342D.6030609@cn.fujitsu.com> <20090303140955.GD23822@elte.hu>
	 <49AE484C.8020801@cn.fujitsu.com> <20090304114504.GB4916@elte.hu>
Date: Wed, 4 Mar 2009 14:00:54 +0200
X-Google-Sender-Auth: a362c7f6b0ed5c8b
Message-ID: <84144f020903040400m5a77fc4p2b09796e1111c3b9@mail.gmail.com>
Subject: Re: [PATCH -mm 0/6] rcu: introduce kfree_rcu V2
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Manfred Spraul <manfred@colorfullife.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 4, 2009 at 1:45 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> This is one of patches I test kfree_rcu().
>> And it could be an example conversions of this facility.
>>
>> ---
>>  arch/ia64/sn/kernel/irq.c           |   14 +-----------
>>  block/genhd.c                       |   10 --------
>>  ipc/sem.c                           |   10 +-------
>>  kernel/audit_tree.c                 |    8 ------
>>  kernel/cgroup.c                     |    9 -------
>>  kernel/smp.c                        |   11 ---------
>>  mm/vmalloc.c                        |   18 +--------------
>>  net/can/af_can.c                    |   14 +-----------
>>  net/core/gen_estimator.c            |    9 -------
>>  net/core/net_namespace.c            |   10 --------
>>  net/ipv4/fib_trie.c                 |    7 ------
>>  net/ipv6/addrconf.c                 |   10 --------
>>  net/netfilter/nf_conntrack_extend.c |    8 ------
>>  net/netlabel/netlabel_unlabeled.c   |   42 +-----------------------------------
>>  security/device_cgroup.c            |   10 --------
>>  security/keys/keyring.c             |   15 ------------
>>  security/keys/user_defined.c        |   18 +--------------
>>  security/selinux/netif.c            |   18 ---------------
>>  security/selinux/netnode.c          |   20 +----------------
>>  security/selinux/netport.c          |   20 +----------------
>>  20 files changed, 28 insertions(+), 253 deletions(-)
>
> Looks convincing to me but Nick does not like the extra SLAB
> field it uses :-/

FWIW, I'm fine with the patch series. One option for SLQB is to just
remove slab coloring as I've suggested in the past (the performance
benefit with current cpu caches is questionable).

                                     Pekka
