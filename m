Return-Path: <linux-kernel-owner+w=401wt.eu-S1758006AbZBSMHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006AbZBSMHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 07:07:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbZBSMHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 07:07:03 -0500
Received: from smtp120.mail.mud.yahoo.com ([209.191.84.77]:42573 "HELO
	smtp120.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751563AbZBSMHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 07:07:01 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=A3b7edsnsf4Bni+WQj81haqMxzuWnSDHDC66i5g/3EzbFxM0ceePkVwB9QllkQlGy/HW8dlKRkWvPgIuOWyB5bMztc5JdvPonXbm/UanN/xey+CkG7ZkmbMwYV3bo8Stu1PcVHxJJLTZ9l6eympTgZ40ets4cEznnmpjnyS/saM=  ;
X-YMail-OSG: zVZG69IVM1lRNPXmiAIUY.CdC26geUhix12ShTMWAMYC8VYJ88hjpof1AkWzFbVnsshSG8dJv14K0HFHmfomClhqFPhYmWO5VE4jGaN0v63TBhkokrHALzgKquFaklr7tLhhNDutbocTTIDmH_RFPNNxwPU5tVc7TYTttMNXtnyH42.d4PYWFa3aNzLeSejQzAcq9Dz4umVDHdiehLuaYjQN6fA-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 01/10] vmalloc: call flush_cache_vunmap() from unmap_kernel_range()
Date: Thu, 19 Feb 2009 23:06:27 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <1234958676-27618-2-git-send-email-tj@kernel.org>
In-Reply-To: <1234958676-27618-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902192306.28360.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 February 2009 23:04:27 Tejun Heo wrote:
> Impact: proper vcache flush on unmap_kernel_range()
>
> flush_cache_vunmap() should be called before pages are unmapped.  Add
> a call to it in unmap_kernel_range().
>
> Signed-off-by: Tejun Heo <tj@kernel.org>

Shouldn't this go as a fix to mainline and even .stable?

Otherwise:
Acked-by: Nick Piggin <npiggin@suse.de>

> ---
>  mm/vmalloc.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 75f49d3..c37924a 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -1012,6 +1012,8 @@ void __init vmalloc_init(void)
>  void unmap_kernel_range(unsigned long addr, unsigned long size)
>  {
>  	unsigned long end = addr + size;
> +
> +	flush_cache_vunmap(addr, end);
>  	vunmap_page_range(addr, end);
>  	flush_tlb_kernel_range(addr, end);
>  }


