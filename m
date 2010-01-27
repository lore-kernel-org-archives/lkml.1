Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485Ab0A0AH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab0A0AH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992Ab0A0AHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:07:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754041Ab0A0AHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 19:07:21 -0500
Date: Tue, 26 Jan 2010 16:06:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       Roland McGrath <roland@redhat.com>, WANG Cong <amwang@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs/binfmt_elf.c: fix a do-while statement.
Message-Id: <20100126160632.3bdbe172.akpm@linux-foundation.org>
In-Reply-To: <c370b092a68e66a2ac6c9d852967d843a1b574c0.1264046338.git.tfransosi@gmail.com>
References: <c370b092a68e66a2ac6c9d852967d843a1b574c0.1264046338.git.tfransosi@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010 23:03:53 -0500
Thiago Farina <tfransosi@gmail.com> wrote:

> warning: do-while statement is not a compound statement
> 
> Signed-off-by: Thiago Farina <tfransosi@gmail.com>
> ---
>  fs/binfmt_elf.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index edd90c4..75d6468 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -1404,9 +1404,9 @@ static void fill_auxv_note(struct memelfnote *note, struct mm_struct *mm)
>  {
>  	elf_addr_t *auxv = (elf_addr_t *) mm->saved_auxv;
>  	int i = 0;
> -	do
> +	do {
>  		i += 2;
> -	while (auxv[i - 2] != AT_NULL);
> +	} while (auxv[i - 2] != AT_NULL);
>  	fill_note(note, "CORE", NT_AUXV, i * sizeof(elf_addr_t), auxv);
>  }

hmpf.  Which tool emitted that warning?  sparse?

It is somewhat unconventional coding style and it'd be good if
checkpatch were to warn so that we don't _add_ such things to the tree.

But IMO it's such a minor thing that once it _is_ in the tree, it's not
really worth the patch noise to go and fix it up.


