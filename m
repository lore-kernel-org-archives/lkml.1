Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbYJJD2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbYJJD2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 23:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbYJJD2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 23:28:31 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:47447 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751539AbYJJD2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 23:28:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=iEFx9mrau2rDknFyL0/981wqNSxdX1fdb/LcKVZuvvQI9AtcxSvjNTHCPiFUjMw866CBEvliMe0UdW/ITq7BufboyzWuYm/M2SY8M4g86dPYgpJ5nGwl7ze5uWDe96H20T0qu5/NppkAX7Al1TYHcr3lW4hLtbBhm71JGEkmano=  ;
X-YMail-OSG: QhvqiYIVM1kQPoR3rMMjzXeFfwsMlDmifsQGnYszSr_QjFSM9GfpgMUcrqF.SdOy8WFfKtl0FL0fCmhhYTwOIuW__h.Qq5vMROw_xIoecE9nPZvBMENst5KiaAB0oG.zp4w1SL7wehrc4HgIor5wVipN9MdI1yywMOtijojzF.XA9NrjSs972byWLzOj
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Dave Jones <davej@redhat.com>
Subject: Re: Update cacheline size on X86_GENERIC
Date: Fri, 10 Oct 2008 14:28:23 +1100
User-Agent: KMail/1.9.5
Cc: x86@kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
References: <20081009171453.GA15321@redhat.com>
In-Reply-To: <20081009171453.GA15321@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810101428.23662.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 October 2008 04:14, Dave Jones wrote:
> I just noticed that configuring a kernel to use CONFIG_X86_GENERIC
> (as is typical for a distro kernel) configures it to use a 128 byte
> cacheline size. This made sense when that was commonplace (P4 era) but
> current
> Intel, AMD and VIA cpus use 64 byte cachelines.

I think P4 technically did have 64 byte cachelines, but had some adjacent
line prefetching. And AFAIK core2 CPUs can do similar prefetching (but
maybe it's smarter and doesn't cause so much bouncing?).

Anyway, GENERIC kernel should run well on all architectures, and while
going too big causes slightly increased structures sometimes, going too
small could result in horrible bouncing.

Lastly, I think x86 will go to 128 byte lines in the next year or two, so
maybe at this point we can just keep 128 byte alignment?

/random thoughts

>
> Signed-off-by: Dave Jones <davej@redhat.com>
>
> --- linux-2.6.26.noarch/arch/x86/Kconfig.cpu~	2008-10-09 12:59:56.000000000
> -0400 +++ linux-2.6.26.noarch/arch/x86/Kconfig.cpu	2008-10-09
> 13:11:32.000000000 -0400 @@ -301,8 +301,8 @@ config X86_CPU
>  # Define implied options from the CPU selection here
>  config X86_L1_CACHE_BYTES
>  	int
> -	default "128" if GENERIC_CPU || MPSC
> -	default "64" if MK8 || MCORE2
> +	default "128" if MPENTIUM4 || MPSC
> +	default "64" if MK8 || MCORE2 || GENERIC_CPU
>  	depends on X86_64
>
>  config X86_INTERNODE_CACHE_BYTES
> @@ -316,10 +316,10 @@ config X86_CMPXCHG
>
>  config X86_L1_CACHE_SHIFT
>  	int
> -	default "7" if MPENTIUM4 || X86_GENERIC || GENERIC_CPU || MPSC
> +	default "7" if MPENTIUM4 || MPSC
>  	default "4" if X86_ELAN || M486 || M386 || MGEODEGX1
>  	default "5" if MWINCHIP3D || MWINCHIP2 || MWINCHIPC6 || MCRUSOE ||
> MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 ||
> M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX -	default "6" if MK7 ||
> MK8 || MPENTIUMM || MCORE2 || MVIAC7
> +	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MVIAC7 || X86_GENERIC
> || GENERIC_CPU
>
>  config X86_XADD
>  	def_bool y
