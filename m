Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbZJSDjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbZJSDjH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 23:39:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbZJSDjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 23:39:07 -0400
Received: from lo.gmane.org ([80.91.229.12]:52362 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125AbZJSDjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 23:39:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Raja R Harinath <harinath@hurrynot.org>
Subject: Re: [RFC][PATCH 2/4] mm: stack based kmap_atomic
Date: Mon, 19 Oct 2009 08:38:12 +0530
Message-ID: <87tyxw13oj.fsf@hariville.hurrynot.org>
References: <20091008232226.768382977@chello.nl>
	<20091008232528.365592989@chello.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 59.96.63.58
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
Cancel-Lock: sha1:fWtyGmAncqsOfUg8xoyyiuxjqbw=
Cc: linux-arch@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Peter Zijlstra <a.p.zijlstra@chello.nl> writes:

> @@ -74,7 +76,10 @@ EXPORT_SYMBOL(kmap_atomic);
>  void kunmap_atomic(void *kvaddr, enum km_type type)
>  {
>  	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
> -	unsigned int idx = type + KM_TYPE_NR * smp_processor_id();
> +	unsigned int idx;
> +
> +	type = kmap_atomic_idx_pop();
> +	idx = type + KM_TYPE_NR * smp_processor_id();

Maybe you can avoid the 4/4 patch and preserve clean bisects by renaming
the unused parameter here and elsewhere, and introduce the 'type' local
in this patch.

  void kunmap_atomic(void *kvaddr, enum km_type unused)
  {
    ...
    unsigned int idx, type;
    ...
  }

That way, patch 3/4 will remove a genuinely unused parameter, and thus
remain compile-able.

- Hari

