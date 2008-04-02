Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbYDBLLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbYDBLLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 07:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbYDBLLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 07:11:43 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:56002 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbYDBLLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:11:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=BDGSBhd2xt95PHOzfPXv5QvxTBqxynvDYGS2hkFDUSvlG2n2ra4K1WMUIcAJoUA5G0Gn3+tMCg1b4g4WXUF1f0WutiI8L3HzvBW3903E7un3RHdlLDGXAJB6ViWHO4qypiManOvn5Oszt6RXSze/r9gENXxVBmPkcW7s7XHnbI4=
Message-ID: <84144f020804020411m7c6b0f27w16e8c6500867f3c1@mail.gmail.com>
Date: Wed, 2 Apr 2008 14:11:42 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: kmemcheck caught read from freed memory (cfq_free_io_context)
Cc: "Jens Axboe" <jens.axboe@oracle.com>, paulmck@linux.vnet.ibm.com,
       "Ingo Molnar" <mingo@elte.hu>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <1207134536.8514.773.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0804011408v19e13b6cje1ca89a2a471484c@mail.gmail.com>
	 <1207085788.29991.6.camel@lappy> <20080402071709.GC12774@kernel.dk>
	 <Pine.LNX.4.64.0804021020280.25738@sbz-30.cs.Helsinki.FI>
	 <20080402072456.GI12774@kernel.dk> <20080402072846.GA16454@elte.hu>
	 <20080402105539.GA5610@linux.vnet.ibm.com>
	 <84144f020804020401j4e5863dcofd16662baa54574@mail.gmail.com>
	 <20080402110718.GU12774@kernel.dk> <1207134536.8514.773.camel@twins>
X-Google-Sender-Auth: a3efcfdbf1a6b90e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-02 at 13:07 +0200, Jens Axboe wrote:
> > Makes sense, and to me Pauls analysis of the code looks totally correct
> > - there's no bug there, at least related to hlist traversal and
> > kmem_cache_free(), since we are under rcu_read_lock() and thus hold off
> > the grace for freeing.

On Wed, Apr 2, 2008 at 2:08 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>  but what holds off the slab allocator re-issueing that same object and
>  someone else writing other stuff into it?

Nothing. So you cannot access the object at all after you've called
kmem_cache_free(). SLAB_RCU or no SLAB_RCU.
