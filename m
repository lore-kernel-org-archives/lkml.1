Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbXEACXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbXEACXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 22:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbXEACXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 22:23:30 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754481AbXEACX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 22:23:29 -0400
Date: Mon, 30 Apr 2007 19:22:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [patch] pci: type may be unused in pci_access_init()
Message-Id: <20070430192250.1967a77b.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704291659480.1822@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0704291659480.1822@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007 07:34:52 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> The automatic 'type' variable is unused in !CONFIG_PCI_DIRECT and
> !CONFIG_PCI_MMCONFIG.
> 
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  arch/i386/pci/init.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/i386/pci/init.c b/arch/i386/pci/init.c
> --- a/arch/i386/pci/init.c
> +++ b/arch/i386/pci/init.c
> @@ -6,7 +6,7 @@

Please use `diff -p'.

>     in the right sequence from here. */
>  static __init int pci_access_init(void)
>  {
> -	int type = 0;
> +	int type __attribute__((unused)) = 0;

We have __attribute_used__ for this, but the implementation looks whacky:
it's there for gcc-3 but not for gcc-4 and the intel compiler.

But it looks like the gcc-3 version is there to iron over a gcc
implementation glitch.

>  #ifdef CONFIG_PCI_DIRECT
>  	type = pci_direct_probe();

Of course, one could do 

	int type = pci_direct_probe();

here instead, but that's a bit fragile.
