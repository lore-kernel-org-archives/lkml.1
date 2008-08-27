Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbYH0Ng0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbYH0Ng0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbYH0NgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:36:17 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:34854 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754982AbYH0NgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:36:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JyitovVYemAsXE/M7nB2CNVVA01y2neBPs9vg0ysOLnh/k4BNX4dPDpeSig98DDgfoBMKv6mlD/pF1UQYoRiZi5dOhMGRr3X5bQN5MEV6+bLq2dzBJ5HOygp+2t8sF7Zylp9e5iJohlbx8yJMiIZUC76AXd2yeK4qfNZDkv7RC8=  ;
X-YMail-OSG: PvzPnE8VM1nj58ZTbwsZjHBBj.2tARI0DeT9dIr547yPVTIHehjPD3RnmxUjguw4dggR8O6BmioxAk2wL3L9DVFrpaY_pOGlZM6LeOvbMfaTgD7_ksJyD3vjXXwJ8uREzS8t8EOtmf9RkVQJsQsfak1I
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Eric Anholt <eric@anholt.net>, Dave Airlie <airlied@gmail.com>,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] Export kmap_atomic_pfn for DRM-GEM.
Date: Wed, 27 Aug 2008 23:36:05 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <1219779789-8368-1-git-send-email-eric@anholt.net> <1219779789-8368-2-git-send-email-eric@anholt.net> <1219779789-8368-3-git-send-email-eric@anholt.net>
In-Reply-To: <1219779789-8368-3-git-send-email-eric@anholt.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808272336.05736.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 August 2008 05:43, Eric Anholt wrote:
> The driver would like to map IO space directly for copying data in when
> appropriate, to avoid CPU cache flushing for streaming writes.
> kmap_atomic_pfn lets us avoid IPIs associated with ioremap for this
> process.
>
> Signed-off-by: Eric Anholt <eric@anholt.net>
> ---
>  arch/x86/mm/highmem_32.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
> index 165c871..d52e91d 100644
> --- a/arch/x86/mm/highmem_32.c
> +++ b/arch/x86/mm/highmem_32.c
> @@ -137,6 +137,7 @@ void *kmap_atomic_pfn(unsigned long pfn, enum km_type
> type)
>
>  	return (void*) vaddr;
>  }
> +EXPORT_SYMBOL(kmap_atomic_pfn);
>
>  struct page *kmap_atomic_to_page(void *ptr)
>  {


I wonder if you ever tested my vmap rework patches with this issue? It
seems somewhat x86 specific and also not conceptually so clean to use
kmap_atomic_pfn for this. vmap may not be used by all architectures but
I think it might be able to cover some of them.

As I said, there are some other possible improvements that can be made
to my vmap rewrite if performance isn't good enough, but I simply have
not seen numbers...

Thanks,
Nick
