Return-Path: <linux-kernel-owner+w=401wt.eu-S1759872AbZFXVkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759872AbZFXVkQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 17:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949AbZFXVkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 17:40:06 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:64104 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752864AbZFXVkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 17:40:05 -0400
From: Frans Pop <elendil@planet.nl>
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: shmem_get_acl: unable to handle kernel paging request at ffffffffffffffff
Date: Wed, 24 Jun 2009 23:40:05 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200906242316.05073.elendil@planet.nl> <20090624211752.GY8633@ZenIV.linux.org.uk>
In-Reply-To: <20090624211752.GY8633@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906242340.06958.elendil@planet.nl>
X-OriginalArrivalTime: 24 Jun 2009 21:40:07.0637 (UTC) FILETIME=[57B48850:01C9F514]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 June 2009, Al Viro wrote:
> On Wed, Jun 24, 2009 at 11:16:03PM +0200, Frans Pop wrote:
> > I just tried v2.6.30-8722-gc82e6d4 on VirtualBox (x86_64) and got a
> > crash. Last tested/working version: v2.6.30-6553-g65795ef.
>
> Fixed in vfs-2.6.git for-linus...

Pulled, built, tested, check...
Wow, we're fast today.

Looks like resource allocation got improved:
-pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
-pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
+pci_bus 0000:00: resource 0 io:  [0x00-0xcf7]
+pci_bus 0000:00: resource 1 io:  [0xd00-0xffff]
+pci_bus 0000:00: resource 2 mem: [0x0a0000-0x0bffff]
+pci_bus 0000:00: resource 3 mem: [0x10000000-0xffdfffff]

Thanks,
FJP

P.S. Just see we're rid of 'Driver 's{dr}' needs updating - please use 
bus_type methods'. Yay!
