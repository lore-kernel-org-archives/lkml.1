Return-Path: <linux-kernel-owner+w=401wt.eu-S1757772AbXKIXBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772AbXKIXBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:01:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbXKIXBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:01:43 -0500
Received: from gw.goop.org ([64.81.55.164]:41523 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbXKIXBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:01:43 -0500
Message-ID: <4734E6A0.6070508@goop.org>
Date: Fri, 09 Nov 2007 15:00:48 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: linux-kernel@vger.kernel.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, ak@suse.de,
       virtualization@lists.linux-foundation.org, chrisw@sous-sol.org,
       tglx@linutronix.de, anthony@codemonkey.ws, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu
Subject: Re: [PATCH 1/24] mm/sparse-vmemmap.c: make sure init_mm is included
References: <11946337851964-git-send-email-gcosta@redhat.com> <11946337933104-git-send-email-gcosta@redhat.com>
In-Reply-To: <11946337933104-git-send-email-gcosta@redhat.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> mm/sparse-vmemmap.c uses init_mm in some places.  However, it is not
> present in any of the headers currently included in the file.
>
> init_mm is defined as extern in sched.h, so we add it to the headers list
>
> Up to now, this problem was masked by the fact that functions like
> set_pte_at() and pmd_populate_kernel() are usually macros that expand to
> simpler variants that does not use the first parameter at all.
>
> Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  mm/sparse-vmemmap.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index d3b718b..22620f6 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -24,6 +24,7 @@
>  #include <linux/module.h>
>  #include <linux/spinlock.h>
>  #include <linux/vmalloc.h>
> +#include <linux/sched.h>
>   

This is already in git.

    J
