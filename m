Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab0BHSpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 13:45:42 -0500
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:50768 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753363Ab0BHSpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 13:45:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=hF780VvZaizdPwoncM9kVwAYJaTVMtten8cHGqTCbMp01DaOuprEViy9blb3OmHNMg4pNLzJ04U3bpNIw28kY0uYxkeDvjjr5VnGGuOnySul83/Nj1/PZtB08jcZK73C;
Date: Mon, 8 Feb 2010 10:44:26 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       linux-pci@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/1] X86: pci, fix section mismatch
Message-ID: <20100208104426.50bef125@jbarnes-piketon>
In-Reply-To: <1264756956-30006-1-git-send-email-jslaby@suse.cz>
References: <1264756956-30006-1-git-send-email-jslaby@suse.cz>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jan 2010 10:22:36 +0100
Jiri Slaby <jslaby@suse.cz> wrote:

> pcibios_scan_specific_bus calls pci_scan_bus_on_node which is
> __devinit. Mark pcibios_scan_specific_bus __devinit as well since
> all users are now __init or __devinit.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: linux-pci@vger.kernel.org
> Cc: x86@kernel.org
> ---
>  arch/x86/pci/legacy.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
> index a8194c8..8cf7835 100644
> --- a/arch/x86/pci/legacy.c
> +++ b/arch/x86/pci/legacy.c
> @@ -39,7 +39,7 @@ static int __init pci_legacy_init(void)
>  	return 0;
>  }
>  
> -void pcibios_scan_specific_bus(int busn)
> +void __devinit pcibios_scan_specific_bus(int busn)
>  {
>  	int devfn;
>  	long node;

Does this apply to some x86 tree that I can't see?  Neither my tree nor
the -tip tree has this function and I don't see it in the history.

-- 
Jesse Barnes, Intel Open Source Technology Center
