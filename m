Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbXEADVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbXEADVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 23:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755461AbXEADVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 23:21:12 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754693AbXEADVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:21:11 -0400
Date: Mon, 30 Apr 2007 20:20:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [patch] pci: type may be unused in pci_access_init()
Message-Id: <20070430202059.de539790.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704301934320.32426@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0704291659480.1822@chino.kir.corp.google.com>
	<20070430192250.1967a77b.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704301934320.32426@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007 19:46:12 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> So, due to the whacky implementation of __attribute_used__, we can just do 
> this:
> ---
>  arch/i386/pci/init.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/i386/pci/init.c b/arch/i386/pci/init.c
> index b21b6da..508d6fd 100644
> --- a/arch/i386/pci/init.c
> +++ b/arch/i386/pci/init.c
> @@ -6,7 +6,9 @@
>     in the right sequence from here. */
>  static __init int pci_access_init(void)
>  {
> +#if defined(CONFIG_PCI_DIRECT) || defined(CONFIG_PCI_MMCONFIG)
>  	int type = 0;
> +#endif

Drat, I was hoping someone would unwhacky __attribute_used__.
