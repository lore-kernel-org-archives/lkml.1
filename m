Return-Path: <linux-kernel-owner+w=401wt.eu-S1753041AbYDBLBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbYDBLBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 07:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbYDBLBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 07:01:17 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:41324 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbYDBLBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:01:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=LIhQqaqADGSguQBeuffHVCp6eYNKpZ02Yuix/ZPSAp4t+7Go+NKDLRVQuTGeDaSu+T9sV2p2Y0QQ5N7eKOK0XYP90yEdNba7HCIJEzgkiYjWnaL1bWL/NvAT4V9KdWy0siiAG6kOgMqXMIdCv42k06zOlQ6RLzoxIG7NoyGSyf4=
Message-ID: <84144f020804020401j4e5863dcofd16662baa54574@mail.gmail.com>
Date: Wed, 2 Apr 2008 14:01:13 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: paulmck@linux.vnet.ibm.com
Subject: Re: kmemcheck caught read from freed memory (cfq_free_io_context)
Cc: "Ingo Molnar" <mingo@elte.hu>, "Jens Axboe" <jens.axboe@oracle.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080402105539.GA5610@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0804011408v19e13b6cje1ca89a2a471484c@mail.gmail.com>
	 <1207085788.29991.6.camel@lappy> <20080402071709.GC12774@kernel.dk>
	 <Pine.LNX.4.64.0804021020280.25738@sbz-30.cs.Helsinki.FI>
	 <20080402072456.GI12774@kernel.dk> <20080402072846.GA16454@elte.hu>
	 <20080402105539.GA5610@linux.vnet.ibm.com>
X-Google-Sender-Auth: 5adf9ad90a727635
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Wed, Apr 2, 2008 at 1:55 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>  I will check this when I get back to some bandwidth -- but in the meantime,
>  does kmemcheck special-case SLAB_DESTROY_BY_RCU?  It is legal to access
>  newly-freed items in that case, as long as you did rcu_read_lock()
>  before gaining a reference to them and don't hold the reference past
>  the matching rcu_read_unlock().

No, kmemcheck is work in progress and does not know about
SLAB_DESTROY_BY_RCU yet. The reason I asked Vegard to post the warning
was because Peter, Vegard, and myself identified this particular
warning as a real problem. But yeah, kmemcheck can cause false
positives for RCU for now.

                               Pekka
