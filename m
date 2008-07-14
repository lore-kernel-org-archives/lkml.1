Return-Path: <linux-kernel-owner+w=401wt.eu-S1757444AbYGNVVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbYGNVVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 17:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756123AbYGNVVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 17:21:13 -0400
Received: from outbound-mail-128.bluehost.com ([67.222.38.28]:49818 "HELO
	outbound-mail-128.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755887AbYGNVVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 17:21:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User:DomainKey-Status;
	b=SMpl0QXKD7jQppPJOaSNnWmFchv+Dn+H8g0pPxtg2Kyg+ZZPonjXKxz0ykIvf50Vh7ubGRLofinhBKmkgDAiWNj7uV7+Aoi56eqN3d9WdJHzPnAZtSkYdSPxI9b7SJa3;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Fix pci_subsys_init() to have a return value
Date: Mon, 14 Jul 2008 14:21:03 -0700
User-Agent: KMail/1.9.9
Cc: akpm@linux-foundation.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20080711094636.18199.94804.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080711094636.18199.94804.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807141421.03305.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 11, 2008 2:46 am David Howells wrote:
> Fix pci_subsys_init() to return a value (0) when it has finished.  All the
> functions it calls currently return 0, so returning 0 here unconditionally
> rather than gathering the results of its callees would seem reasonable.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>
>  arch/x86/pci/legacy.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
>
> diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
> index 3c1d795..00e29c8 100644
> --- a/arch/x86/pci/legacy.c
> +++ b/arch/x86/pci/legacy.c
> @@ -63,5 +63,6 @@ int __init pci_subsys_init(void)
>  	pci_legacy_init();
>  	pcibios_irq_init();
>  	pcibios_init();
> +	return 0;
>  }
>  subsys_initcall(pci_subsys_init);

Looks like Robert already pushed a patch like this via the x86 tree, but at 
least it's been fixed.

Thanks,
Jesse
