Return-Path: <linux-kernel-owner+w=401wt.eu-S1754474AbYJGLIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbYJGLIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 07:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbYJGLIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 07:08:24 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34559 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbYJGLIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 07:08:23 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH, RFC] shmat: introduce flag SHM_MAP_HINT
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1223303879-5555-1-git-send-email-kirill@shutemov.name>
References: <20081006132651.GG3180@one.firstfloor.org> <1223303879-5555-1-git-send-email-kirill@shutemov.name>
Message-Id: <20081007195837.5A6B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue,  7 Oct 2008 20:08:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It allows interpret attach address as a hint, not as exact address.
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arjan van de Ven <arjan@infradead.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  include/linux/shm.h |    1 +
>  ipc/shm.c           |    4 ++--
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/shm.h b/include/linux/shm.h
> index eca6235..2a637b8 100644
> --- a/include/linux/shm.h
> +++ b/include/linux/shm.h
> @@ -55,6 +55,7 @@ struct shmid_ds {
>  #define	SHM_RND		020000	/* round attach address to SHMLBA boundary */
>  #define	SHM_REMAP	040000	/* take-over region on attach */
>  #define	SHM_EXEC	0100000	/* execution access */
> +#define	SHM_MAP_HINT	0200000	/* interpret attach address as a hint */

hmm..
Honestly, I don't like that qemu specific feature insert into shmem core.
At least, this patch is too few comments.
Therefore, an develpper can't understand why SHM_MAP_HINT exist.

I think this patch description is too short and too poor.
I don't like increasing mysterious interface.


