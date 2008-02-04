Return-Path: <linux-kernel-owner+w=401wt.eu-S1757521AbYBDTXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521AbYBDTXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 14:23:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754437AbYBDTW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 14:22:57 -0500
Received: from smtp-out.google.com ([216.239.45.13]:16146 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbYBDTW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 14:22:56 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=ccTgNv0iRJW8DVgad8QtTevsXu8p3kBkquYvcGXsNfoG7NQE5vI3euBTx7DCeP5b+
	d5L4YNTVbRCKDA/tzbThA==
Message-ID: <3f1a065b0802041122t6cec1803r89cdcd380fb3b5c0@mail.gmail.com>
Date: Mon, 4 Feb 2008 11:22:50 -0800
From: "Russell Leidich" <rml@google.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] Remove Barcelona Thermal Throttling
Cc: "Torsten Kaiser" <just.for.lkml@googlemail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@elte.hu>, valdis.kletnieks@vt.edu
In-Reply-To: <20080204072013.GB571@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3f1a065b0802032213j713fe551t9a0642ea2b83994@mail.gmail.com>
	 <20080204072013.GB571@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 3, 2008 11:20 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Sun, Feb 03, 2008 at 10:13:53PM -0800, Russell Leidich wrote:
> > All,
> >
> > You can imagine my dismay when I recently learned that, after all our
> > collective effort, hardware thermal throttling does not work reliably
> > on Barcelona, according to AMD.  Due to NDA restrictions, I am unable
> > to provide further details.
>
> Too bad. Hopefully that code will work then on the hypothetic
> future parts with fixed throttling. Perhaps it would be better
> to just remove it now and readd later.

I really think it's best to leave it in.  It's harmless at the moment,
and readding it later will just create a massive amount of duplicate
work.    Sooner or later, I'm have little doubt that AMD can make this
feature work.

>
> All this reminds me you need to adjust the Kconfig dependencies
> for K8_NB too to be always enabled with MCE_AMD.
>
> Ideally on top of this patch with a || MCE_AMD

OK, if you'll take the patch, I'd be happy to do this :).  I'm
assuming that you mean I should force K8_NB = "yes" if MCE_AMD = "yes"
in .config.  Is that what you're asking for?

>
> -Andi
>
> ---
>
> Fix and simplify k8.c Kconfig dependencies
>
> - Check for K8_NUMA instead of NUMA && PCI
> - No need to check for x86_64 explicitely
>
> Signed-off-by: Andi Kleen <ak@suse.de>
>
> Index: linux/arch/x86/Kconfig
> ===================================================================
> --- linux.orig/arch/x86/Kconfig
> +++ linux/arch/x86/Kconfig
> @@ -1540,7 +1540,7 @@ endif # X86_32
>
>  config K8_NB
>         def_bool y
> -       depends on AGP_AMD64 || (X86_64 && (GART_IOMMU || (PCI && NUMA)))
> +       depends on AGP_AMD64 || GART_IOMMU || K8_NUMA
>
>  source "drivers/pcmcia/Kconfig"
>
>



-- 
Russell Leidich
