Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbZLRR2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbZLRR2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:28:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbZLRR2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:28:52 -0500
Received: from outbound-mail-20.bluehost.com ([69.89.20.235]:44787 "HELO
	outbound-mail-20.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750771AbZLRR2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:28:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Lop9YTOSI2TVBvXJFH0m18Dzc3tRuPRAbSCr+9rjeXl6Jqrphs5xrQ+yC8JqCQiK5FI1wvoTrNMAl1N4PqpULdS/XJU04xjEZYasMX9qVmOSL7c411y1cfCQ0UJO5YBx;
Date: Fri, 18 Dec 2009 09:28:14 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: tj@kernel.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-netdev@vger.kernel.org
Subject: Re: intelligent CLS kills qemu's 8139cp
Message-ID: <20091218092814.12b535b5@jbarnes-piketon>
In-Reply-To: <b6fcc0a0912180549u6970ceden53dc919bae52452e@mail.gmail.com>
References: <b6fcc0a0912180549u6970ceden53dc919bae52452e@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Dec 2009 15:49:18 +0200
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> After this patch qemu's 8139cp won't be initialized resulting in no
> network. It einvals in pci_set_cacheline_size() where
> pci_cache_line_size=0
> 
> PCI: CLS 0 bytes, default 32
> 
> ac1aa47b131416a6ff37eb1005a0a1d2541aad6c is first bad commit
> commit ac1aa47b131416a6ff37eb1005a0a1d2541aad6c
> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> Date:   Mon Oct 26 13:20:44 2009 -0700
> 
>     PCI: determine CLS more intelligently

My for-linus branch has

commit 2820f333e3b4ad96590093efbed7b3400bcf492b
Author: Csaba Henk <csaba@gluster.com>
Date:   Tue Dec 15 17:55:25 2009 +0530

    PCI: Handle case when no pci device can provide cache line size hint

which may fix this issue.  You can grab my tree from
git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6

Jesse

-- 
Jesse Barnes, Intel Open Source Technology Center
