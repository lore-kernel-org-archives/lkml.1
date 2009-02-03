Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbZBCQpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbZBCQpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 11:45:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbZBCQoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 11:44:54 -0500
Received: from rv-out-0506.google.com ([209.85.198.234]:36338 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbZBCQox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 11:44:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ukyF7oh0tc4hr2YRMIlhJbM1FfxYXJmQ+1NeFDmAr5jHHp1cQ7xaYP4SkbanSe7c9R
         I+WSzM/yujutvWV2C4brHcDZIOCHYmvrYtucOLN2MvhvT6dy0WogtYztxNbgDJYN7t3P
         TdsxKGaUw0R83RwyXHQYPNcyViuqZz/0p7VsY=
MIME-Version: 1.0
In-Reply-To: <20090203042405.GB16179@barrios-desktop>
References: <20090203042405.GB16179@barrios-desktop>
Date: Wed, 4 Feb 2009 01:44:52 +0900
X-Google-Sender-Auth: b9fa98029a8703ce
Message-ID: <2f11576a0902030844l64c25496sa5f2892bbb04e47c@mail.gmail.com>
Subject: Re: [PATCH v2] fix mlocked page counter mistmatch
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: MinChan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux mm <linux-mm@kvack.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi MinChan,

I'm confusing now.
Can you teach me?

> When I tested following program, I found that mlocked counter
> is strange.
> It couldn't free some mlocked pages of test program.
> It is caused that try_to_unmap_file don't check real
> page mapping in vmas.

What meanining is "real" page mapping?


> That's because goal of address_space for file is to find all processes
> into which the file's specific interval is mapped.
> What I mean is that it's not related page but file's interval.

hmmm. No.
I ran your reproduce program.

two vma pointing the same page cause this leaking.

iow, any library have .text and .data segment. then the tail of .text
and the head of .data vma point the same page.
its page was leaked.


> Even if the page isn't really mapping at the vma, it returns
> SWAP_MLOCK since the vma have VM_LOCKED, then calls
> try_to_mlock_page. After all, mlocked counter is increased again.
>
> COWed anon page in a file-backed vma could be a such case.
> This patch resolves it.

What meaning is "anon page in a file-backed"?
As far as I know, if cow happend on private mapping page, new page is
treated truth anon.


So, I don't reach to your conclusion yet. please teach me.
