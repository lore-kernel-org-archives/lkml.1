Return-Path: <linux-kernel-owner+w=401wt.eu-S1756962AbZBJW6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962AbZBJW6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 17:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757510AbZBJW6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 17:58:24 -0500
Received: from gate.crashing.org ([63.228.1.57]:58815 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756856AbZBJW6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 17:58:22 -0500
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mel Gorman <mel@csn.ul.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>
Message-Id: <B5B23369-BEA0-4420-9967-28ABC53B3C4B@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Frans Pop <elendil@planet.nl>
In-Reply-To: <200902102351.30418.elendil@planet.nl>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH][BUILDERR] mm: Fix build error with !CONFIG_HUGETLBFS
Date: Tue, 10 Feb 2009 16:57:36 -0600
References: <200902102351.30418.elendil@planet.nl>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 10, 2009, at 4:51 PM, Frans Pop wrote:

> In commit 5a6fe1259506 an extra parameter was added to  
> hugetlb_file_setup(),
> but the header file was not updated for the !CONFIG_HUGETLBFS case,  
> which
> results in:
>
> ipc/shm.c:371:49: error: macro "hugetlb_file_setup" passed 3  
> arguments,
>    but takes just 2
>
> Signed-off-by: Frans Pop <elendil@planet.nl>
> Cc: Mel Gorman <mel@csn.ul.ie>
>
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index af09660..03de70f 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -159,9 +159,9 @@ static inline void set_file_hugepages(struct  
> file *file)
> }
> #else /* !CONFIG_HUGETLBFS */
>
> -#define is_file_hugepages(file)		0
> -#define set_file_hugepages(file)	BUG()
> -#define hugetlb_file_setup(name,size)	ERR_PTR(-ENOSYS)
> +#define is_file_hugepages(file)			0
> +#define set_file_hugepages(file)		BUG()
> +#define hugetlb_file_setup(name,size,int)	ERR_PTR(-ENOSYS)

might be slightly better as:

#define hugetlb_file_setup(name,size,acctflag)	ERR_PTR(-ENOSYS)

otherwise ack.

- k
