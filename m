Return-Path: <linux-kernel-owner+w=401wt.eu-S1753883AbYJAPvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbYJAPvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 11:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbYJAPvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 11:51:37 -0400
Received: from outbound-mail-151.bluehost.com ([67.222.39.31]:58217 "HELO
	outbound-mail-151.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750901AbYJAPvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 11:51:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=d1ppjam84Mm4dXI5UIZNtI1o+5Q9aqvLbVyboxn+c/b/63TNAK6T+S7j7CDi+WBaod/SvFqJ9jPKD5he1bkAQFjMN1GxgsqOTGqRexa0HYNirPHP0chAP/XUMjVKvTjA;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: drivers/pci/probe.c compile warnings on -tip
Date: Wed, 1 Oct 2008 08:51:15 -0700
User-Agent: KMail/1.9.10
Cc: "Steven Noonan" <steven@uplinklabs.net>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Hugh Dickins" <hugh@veritas.com>
References: <f488382f0810010102y551f4a3bs64524fa70ef04ca3@mail.gmail.com> <18659.21853.41967.715062@harpo.it.uu.se>
In-Reply-To: <18659.21853.41967.715062@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810010851.15969.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 1, 2008 3:47 am Mikael Pettersson wrote:
> Steven Noonan writes:
>  > I was hunting down some warnings I got when compiling -tip, and with
>  > one of them, I'm not sure what would be a proper way to handle it.
>  >
>  > If CONFIG_PHYS_ADDR_T_64BIT is not enabled, these warnings show up:
>  >
>  > drivers/pci/probe.c: In function '__pci_read_base':
>  > drivers/pci/probe.c:308: warning: format '%llx' expects type 'long
>  > long unsigned int', but argument 4 has type 'resource_size_t'
>  > drivers/pci/probe.c:308: warning: format '%llx' expects type 'long
>  > long unsigned int', but argument 5 has type 'resource_size_t'
>  > drivers/pci/probe.c:320: warning: format '%llx' expects type 'long
>  > long unsigned int', but argument 5 has type 'resource_size_t'
>  > drivers/pci/probe.c:320: warning: format '%llx' expects type 'long
>  > long unsigned int', but argument 6 has type 'resource_size_t'
>  > drivers/pci/probe.c: In function 'pci_read_bridge_bases':
>  > drivers/pci/probe.c:392: warning: format '%llx' expects type 'long
>  > long unsigned int', but argument 3 has type 'resource_size_t'
>  > drivers/pci/probe.c:392: warning: format '%llx' expects type 'long
>  > long unsigned int', but argument 4 has type 'resource_size_t'
>  > drivers/pci/probe.c:405: warning: format '%llx' expects type 'long
>  > long unsigned int', but argument 3 has type 'resource_size_t'
>  > drivers/pci/probe.c:405: warning: format '%llx' expects type 'long
>  > long unsigned int', but argument 4 has type 'resource_size_t'
>  > drivers/pci/probe.c:443: warning: format '%llx' expects type 'long
>  > long unsigned int', but argument 4 has type 'resource_size_t'
>  > drivers/pci/probe.c:443: warning: format '%llx' expects type 'long
>  > long unsigned int', but argument 5 has type 'resource_size_t'
>  >
>  >
>  > Each of the lines is something like this:
>  >
>  > printk(KERN_DEBUG "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
>  > pci_name(dev), pos, res->start, res->end);
>  >
>  > res->start and res->end are resource_size_t (which is phys_addr_t),
>  > and are sized either 32-bit or 64-bit, based on whether
>  > CONFIG_PHYS_ADDR_T_64BIT is set.
>
> Oh not those again. Similar warnings in 27-rc's drivers/pci
> were fixed recently, but apparently someone out there likes
> to create new ones.
>
> The fix is to cast the resource_size_t arguments to unsigned long long.
> With "%llx" that's the /only/ valid argument type.
>
> Also note that these warnings aren't harmless. On 32-bit machines
> with parameters passed on the stack the mismatch in size between
> 32-bit resource_size_t and the 64-bit %llx causes undefined
> behaviour as printk mis-enumerates its parameters.

AFAICT, these are fixed in Linus' tree, maybe the x86 tree needs an update?

-- 
Jesse Barnes, Intel Open Source Technology Center
