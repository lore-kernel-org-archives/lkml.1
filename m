Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbZGVNR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbZGVNR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 09:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbZGVNR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 09:17:57 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:11724 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740AbZGVNR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 09:17:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tj2O8OfsD8hXkK9SvNqPyDsuzWWipQ9CIATAoAeYyHfHXWMq6vDrq36+P9riUXHjnI
         4CRzcf6sj+KjYD2+bnn8EmGROP3dlWi7bQ1PXPnkIxcdEfJRkUB1EiCwzaQ8drhX6eDL
         x7a4qhfYlqbCJ0nPdEBlUh71ABpDgbkSmW3V0=
MIME-Version: 1.0
In-Reply-To: <1248267898.27058.1407.camel@twins>
References: <1248267513-4934-1-git-send-email-tom.leiming@gmail.com>
	 <1248267513-4934-2-git-send-email-tom.leiming@gmail.com>
	 <1248267898.27058.1407.camel@twins>
Date: Wed, 22 Jul 2009 21:17:56 +0800
Message-ID: <d82e647a0907220617p5055ef3bu7f396eda3ac27fa@mail.gmail.com>
Subject: Re: [tip:core/locking 1/3] lockdep:reintroduce generation count to 
	make BFS faster
From: Ming Lei <tom.leiming@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/22 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> On Wed, 2009-07-22 at 20:58 +0800, tom.leiming@gmail.com wrote:
>> From: Ming Lei <tom.leiming@gmail.com>
>>
>> We still can apply DaveM's generation count optimization to
>> BFS, so reintroduce it.
>
> Please elaborate, changelogs are important.

Sorry, I'll resend the patches and provide a elaborate changlogs.


>
> You fail to explain why it still applies and what the gains are.
>
> (I can guess, but you explaining makes sure we're on the same page)
>

gains:
        1), avoid to allocate the bfs_accessed array;

        2), remove the
                    bitmap_zero(bfs_accessed, MAX_LOCKDEP_ENTRIES);
              in each BFS, which is a little time consuming since
MAX_LOCKDEP_ENTRIES
              is very large.(16384UL)

-- 
Lei Ming
