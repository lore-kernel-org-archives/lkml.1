Return-Path: <linux-kernel-owner+w=401wt.eu-S1759356AbXJYFhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356AbXJYFhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 01:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbXJYFh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 01:37:28 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:9854 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbXJYFh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 01:37:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=k8U91ytkT89sB59erdcU6DPtz3aEr5HQE7UHUvXhwLQczMlY8nIC7ZKA3D6pSG7yq0mkGEpq9/napwcyDWqm98Hs5ttddGnW4ZXXHr3K//IF/xryM6AIuNlB1aF2QpBFgwCc+X22qCeZc5KKzJtAfZUq+mqz6ljOCpI+RFWUEr4=
Message-ID: <84144f020710242237q3aa8e96dtc8cf3f02f2af2cc9@mail.gmail.com>
Date: Thu, 25 Oct 2007 08:37:26 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: [PATCH+comment] fix tmpfs BUG and AOP_WRITEPAGE_ACTIVATE
Cc: "Andrew Morton" <akpm@linux-foundation.org>, ezk@cs.sunysb.edu,
       ryan@finnie.org, mhalcrow@us.ibm.com, cjwatson@ubuntu.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, stable@kernel.org
In-Reply-To: <Pine.LNX.4.64.0710242233470.17796@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0710142049000.13119@sbz-30.cs.Helsinki.FI>
	 <200710142232.l9EMW8kK029572@agora.fsl.cs.sunysb.edu>
	 <84144f020710150447o94b1babo8b6e6a647828465f@mail.gmail.com>
	 <Pine.LNX.4.64.0710222101420.23513@blonde.wat.veritas.com>
	 <Pine.LNX.4.64.0710242152020.13001@blonde.wat.veritas.com>
	 <20071024140836.a0098180.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0710242233470.17796@blonde.wat.veritas.com>
X-Google-Sender-Auth: 7c513df83016214a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

On 10/25/07, Hugh Dickins <hugh@veritas.com> wrote:
> --- 2.6.24-rc1/mm/shmem.c       2007-10-24 07:16:04.000000000 +0100
> +++ linux/mm/shmem.c    2007-10-24 22:31:09.000000000 +0100
> @@ -915,6 +915,21 @@ static int shmem_writepage(struct page *
>         struct inode *inode;
>
>         BUG_ON(!PageLocked(page));
> +       /*
> +        * shmem_backing_dev_info's capabilities prevent regular writeback or
> +        * sync from ever calling shmem_writepage; but a stacking filesystem
> +        * may use the ->writepage of its underlying filesystem, in which case

I find the above bit somewhat misleading as it implies that the
!wbc->for_reclaim case can be removed after ecryptfs has similar fix
as unionfs. Can we just say that while BDI_CAP_NO_WRITEBACK does
prevent some callers from entering ->writepage(), it's just an
optimization and ->writepage() must deal with !wbc->for_reclaim case
properly?

                                          Pekka
