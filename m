Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751Ab0CNPB2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 11:01:28 -0400
Received: from mail-pz0-f200.google.com ([209.85.222.200]:58740 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758463Ab0CNPBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 11:01:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=q+oBVi2sew97Pbj9GzcEEHWtffa3LxO/kv2JvAyuh4T6yt06bMtcghvkZlqvikVUmv
         fDPKzOjAlvh8oUfg24aJxXx2giDKoqZxpjAJYN4c3UQ/HJc61P5jWhslf4vnuSn3Xa8G
         xUtaSmCsuo/mIMF6Mmu/0RHuokwllbpBKGB6Y=
MIME-Version: 1.0
In-Reply-To: <1268412087-13536-2-git-send-email-mel@csn.ul.ie>
References: <1268412087-13536-1-git-send-email-mel@csn.ul.ie>
	 <1268412087-13536-2-git-send-email-mel@csn.ul.ie>
Date: Mon, 15 Mar 2010 00:01:24 +0900
Message-ID: <28c262361003140801m44083ad7o784f878d58085948@mail.gmail.com>
Subject: Re: [PATCH 01/11] mm,migration: Take a reference to the anon_vma 
	before migrating
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 13, 2010 at 1:41 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> rmap_walk_anon() does not use page_lock_anon_vma() for looking up and
> locking an anon_vma and it does not appear to have sufficient locking to
> ensure the anon_vma does not disappear from under it.
>
> This patch copies an approach used by KSM to take a reference on the
> anon_vma while pages are being migrated. This should prevent rmap_walk()
> running into nasty surprises later because anon_vma has been freed.
>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

BTW, This another refcount of anon_vma is merged  with KSM by [3/11].
Looks good to me.


-- 
Kind regards,
Minchan Kim
