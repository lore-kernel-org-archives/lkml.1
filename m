Return-Path: <linux-kernel-owner+w=401wt.eu-S1758491AbYAHDIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491AbYAHDIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 22:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755097AbYAHDIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 22:08:21 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39711 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753963AbYAHDIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 22:08:20 -0500
Date: Mon, 7 Jan 2008 19:08:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Adrian Bunk" <bunk@stusta.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: free_pages_check
Message-Id: <20080107190822.b13c9f97.akpm@linux-foundation.org>
In-Reply-To: <86802c440801071843p583f390as53f8b600622b93b2@mail.gmail.com>
References: <86802c440801071843p583f390as53f8b600622b93b2@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2008 18:43:46 -0800 "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> wonder why free_pages_check mm/page_alloc.c is using bit OR than logical OR
> 
> @@ -450,9 +450,9 @@ static inline void __free_one_page(struc
> 
>  static inline int free_pages_check(struct page *page)
>  {
> -       if (unlikely(page_mapcount(page) |
> -               (page->mapping != NULL)  |
> -               (page_count(page) != 0)  |
> +       if (unlikely(page_mapcount(page) ||
> +               (page->mapping != NULL)  ||
> +               (page_count(page) != 0)  ||
>                 (page->flags & (
>                         1 << PG_lru     |
>                         1 << PG_private |

It's a hack^Wtrick to avoid the generation of a series of not-taken
branches.  I don't recall anyone verifying that it is actually of any
benefit, but the theory is good.

The lack of a comment, however, is not.
