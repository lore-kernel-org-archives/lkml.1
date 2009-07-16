Return-Path: <linux-kernel-owner+w=401wt.eu-S1751336AbZGPHMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336AbZGPHMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 03:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbZGPHMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 03:12:38 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:41331 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbZGPHMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 03:12:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=W6uf16LNXEAESLXJ+Z4rbINo6lqStb0dL9ECyV8GeA87R5miw2KSGidHcWlgEl0OWC
         GKZJw8bu5qDYhSTxzOTfJyiKnwwz/Vn86bKszXUFKzhWytW22jk83mHTGYjuLIfVo/ku
         pC4HolviMGcTILpZCYe31ripoZ6P5chTk76ZA=
MIME-Version: 1.0
In-Reply-To: <1247721753.15471.2.camel@twins>
References: <1246201486-7308-1-git-send-email-tom.leiming@gmail.com>
	 <1247476574.7529.55.camel@twins>
	 <d82e647a0907152139x12edd66agde44f155fa60506b@mail.gmail.com>
	 <1247721753.15471.2.camel@twins>
Date: Thu, 16 Jul 2009 15:12:37 +0800
Message-ID: <d82e647a0907160012p4f4ee559q1a04be4cfbc4753c@mail.gmail.com>
Subject: Re: [RESEND PATCH 0/11] kernel:lockdep:replace DFS with BFS
From: Ming Lei <tom.leiming@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/16 Peter Zijlstra <a.p.zijlstra@chello.nl>:
>
> I've asked several times to comment on the removal of that generation
> count DaveM did. Is that a normal part of DFS, or was that an
> optimization on top particular to this problem, can something similar be
> done for BFS, etc.

DFS uses generation count DaveM did to decide if a class is visted, and BFS
uses bitmap to mark a class is visted or not and the extra efficiency loss is

          bitmap_zero(bfs_accessed, MAX_LOCKDEP_ENTRIES);

before staring each BFS.

On most of ARCH, bimap_zero can be optimizied to only consume very few
instructions,
can't it?

It seems bitmap is more easily used in BFS than generation count.

>
> Other than that it does seem to hold up, I've got the patches running on
> my laptop. Don't worry they're not getting lost.

Great.

-- 
Lei Ming
