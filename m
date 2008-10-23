Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbYJWHKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbYJWHKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 03:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755184AbYJWHKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 03:10:31 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:49730 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180AbYJWHK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 03:10:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Hb646ZMoDrTT7usDQ7XUkf2EuVk7z4OE3utf2TAjK3S2gJhgWFFhmQi919zfwm5uD4
         KSv6qGNiwSSD2s75N2L6Xmhbq6vP9OEapLPWbdoIcHzURGei9EdxBzwCk2fvonwa6/O/
         mHBKOJRu2Zr+tUpHb+tbVrPrnyRo6tyEDMwoY=
Message-ID: <86802c440810230010redfbbe7oaf94bf2077ccdcdf@mail.gmail.com>
Date: Thu, 23 Oct 2008 00:10:26 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Yu Zhao" <yu.zhao@intel.com>
Subject: Re: [PATCH 7/16 v6] PCI: cleanup pcibios_allocate_resources()
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "achiang@hp.com" <achiang@hp.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "greg@kroah.com" <greg@kroah.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
In-Reply-To: <20081022084241.GG3773@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081022083809.GA3757@yzhao12-linux.sh.intel.com>
	 <20081022084241.GG3773@yzhao12-linux.sh.intel.com>
X-Google-Sender-Auth: 852bb7df9f57f45f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 1:42 AM, Yu Zhao <yu.zhao@intel.com> wrote:
> This cleanup makes pcibios_allocate_resources() easier to read.
>
> Cc: Alex Chiang <achiang@hp.com>
> Cc: Grant Grundler <grundler@parisc-linux.org>
> Cc: Greg KH <greg@kroah.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Matthew Wilcox <matthew@wil.cx>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Roland Dreier <rdreier@cisco.com>
> Signed-off-by: Yu Zhao <yu.zhao@intel.com>
>
> ---
>  arch/x86/pci/i386.c |   28 ++++++++++++++--------------
>  1 files changed, 14 insertions(+), 14 deletions(-)
>
> diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
> index 844df0c..8729bde 100644
> --- a/arch/x86/pci/i386.c
> +++ b/arch/x86/pci/i386.c
> @@ -147,7 +147,7 @@ static void __init pcibios_allocate_bus_resources(struct list_head *bus_list)
>  static void __init pcibios_allocate_resources(int pass)
>  {
>        struct pci_dev *dev = NULL;
> -       int idx, disabled;
> +       int idx, enabled;
>        u16 command;
>        struct resource *r, *pr;
>
> @@ -160,22 +160,22 @@ static void __init pcibios_allocate_resources(int pass)
>                        if (!r->start)          /* Address not assigned at all */
>                                continue;
>                        if (r->flags & IORESOURCE_IO)
> -                               disabled = !(command & PCI_COMMAND_IO);
> +                               enabled = command & PCI_COMMAND_IO;
>                        else
> -                               disabled = !(command & PCI_COMMAND_MEMORY);
> -                       if (pass == disabled) {
> -                               dev_dbg(&dev->dev, "resource %#08llx-%#08llx (f=%lx, d=%d, p=%d)\n",
> +                               enabled = command & PCI_COMMAND_MEMORY;
> +                       if (pass == enabled)
> +                               continue;

it seems you change the flow here for MMIO
because PCI_COMMAND_MEMORY is 2.

YH
