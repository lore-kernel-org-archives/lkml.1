Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbYJUR2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbYJUR2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 13:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYJUR2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 13:28:40 -0400
Received: from outbound-mail-06.bluehost.com ([69.89.17.206]:47323 "HELO
	outbound-mail-06.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751086AbYJUR2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 13:28:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=HfpK4dXtFWETp1+wnrOXo9Aml0+zi+DFkkUO0YZTa9+1nawX1Uh+FRBZ5N51psBUR2O5vm5XCjIWxTfMCUoscTi47H39cWQarCBF8r2TwKZj2eFf6EPzhnK7uw/a6DUn;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include io.h in pci.h to avoid pci_ioremap build errors
Date: Tue, 21 Oct 2008 10:28:38 -0700
User-Agent: KMail/1.10.1 (Linux/2.6.26.5-45.fc9.x86_64; KDE/4.1.2; x86_64; ; )
References: <200810211007.14378.jbarnes@virtuousgeek.org>
In-Reply-To: <200810211007.14378.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810211028.38630.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 21, 2008 10:07 am Jesse Barnes wrote:
> Ingo pointed out that the m32r build was broken by pci_ioremap.  It looks
> like some files include pci.h w/o including io.h.  The latter defines
> ioremap_* if present, so it makes sense to include it in pci.h now that we
> have pci_ioremap there.
>
> I'll queue this up in my tree for the next pull request, but affected users
> can apply this patch in the meantime.
>
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 085187b..3e2f1d3 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -18,6 +18,7 @@
>  #define LINUX_PCI_H
>
>  #include <linux/pci_regs.h>	/* The pci register defines */
> +#include <asm/io.h>
>
>  /*
>   * The PCI interface treats multi-function devices as independent

The fix I applied to my tree uses linux/io.h instead, which is probably more 
correct (thanks David!).

-- 
Jesse Barnes, Intel Open Source Technology Center

