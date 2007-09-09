Return-Path: <linux-kernel-owner+w=401wt.eu-S1756115AbXIIBXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbXIIBXu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 21:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755068AbXIIBXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 21:23:42 -0400
Received: from mail93.megamailservers.com ([216.251.36.93]:56575 "EHLO
	mail93.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752358AbXIIBXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 21:23:42 -0400
X-Authenticated-User: jgeorgas.georgas.ca
Subject: Re: broken ACPI NUMA config option
From: "James C. Georgas" <jgeorgas@georgas.ca>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070908180904.656f3d03.randy.dunlap@oracle.com>
References: <1189291899.13467.20.camel@Tachyon.home>
	 <20070908180904.656f3d03.randy.dunlap@oracle.com>
Content-Type: text/plain
Organization: Georgas Software Solutions
Date: Sat, 08 Sep 2007 21:22:41 -0400
Message-Id: <1189300961.13467.47.camel@Tachyon.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-08-09 at 18:09 -0700, Randy Dunlap wrote:
> On Sat, 08 Sep 2007 18:51:39 -0400 James C. Georgas wrote:
> 
> > If I select X86_64_ACPI_NUMA, then ACPI_NUMA is (properly) selected
> > automatically, but ACPI is not selected automatically. This causes
> > ACPI_NUMA to not be built, and the kernel compile fails with unresolved
> > symbols.
> 
> exactly what kernel version??
> 
> 

It's 2.6.22.6. I'm thinking a fix would be to add "select PM" to
X86_64_ACPI_NUMA.

I'm also thinking that maybe K8_NUMA should be changed from "depends on
PCI" to "select PCI", like X86_64_ACPI_NUMA is. That would fix the
pseudo dependency they have between them (i.e. selecting
X86_64_ACPI_NUMA causes PCI to be selected, which then makes K8_NUMA
visible, because its PCI dependency is now satisfied).

James
	/\V

