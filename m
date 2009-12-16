Return-Path: <linux-kernel-owner+w=401wt.eu-S935727AbZLPWB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935727AbZLPWB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935715AbZLPWBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:01:54 -0500
Received: from outbound-mail-152.bluehost.com ([67.222.39.32]:47707 "HELO
	outbound-mail-152.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S935713AbZLPWBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:01:50 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=tDmAJgwU02bEp2c6+G4fSARsXZBBA3FR3xYtjLCPRPECS5yuxxT6UUwkXygShb33A/AKgieo9aFLT/fZDtTcz6Bw57mOyOJadYRcVQJkgX5aiZuLpEbGlaVN25OCVoXt;
Date: Wed, 16 Dec 2009 14:01:28 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, blofeldus@yahoo.com,
       Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] cardbus: Add a fixup hook and fix powerpc
Message-ID: <20091216140128.16afbeb7@jbarnes-piketon>
In-Reply-To: <1260341533.16132.20.camel@pasglop>
References: <1260341533.16132.20.camel@pasglop>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Dec 2009 17:52:13 +1100
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> The cardbus code creates PCI devices without ever going through the
> necessary fixup bits and pieces that normal PCI devices go through.
> 
> There's in fact a commented out call to pcibios_fixup_bus() in there,
> it's commented because ... it doesn't work.
> 
> I could make pcibios_fixup_bus() do the right thing on powerpc easily
> but I felt it cleaner instead to provide a specific hook
> pci_fixup_cardbus for which a weak empty implementation is provided
> by the PCI core.
> 
> This fixes cardbus on powerbooks and probably all other PowerPC
> platforms which was broken completely for ever on some platforms and
> since 2.6.31 on others such as PowerBooks when we made the DMA ops
> mandatory (since those are setup by the fixups).
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
> Note: In the long run we might want to streamline the hooks for fixing
> up new devices vs. new busses and make some stuff common between
> cardbus and PCI hotplug which is actually a mess.
> 
> This is a quick fix that makes it work again in the meantime, and that
> I would like to see in 2.6.31 and 2.6.32 stable at least. 
> 
> Another option if you prefer is I can make my pcibios_fixup_bus() do
> the right thing in all cases I believe (by testing bus->is_added to
> skip stuff that must not be done twice) and we can remove the comment
> and stick the call in #ifdef CONFIG_PPC but I felt that solution was
> a tad cleaner.
> 
> Olof, once that's in you should be able to remove the hack you have in
> the PA-Semi code to work around this.
> 

Oops, looks like this fails for the modular case?  I get an unresolved
symbol error when building this with my default config...

Care to resend with the fix against my for-linus branch?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
