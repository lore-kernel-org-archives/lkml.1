Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbZLAU7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbZLAU7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 15:59:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754619AbZLAU7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 15:59:06 -0500
Received: from complete.lackof.org ([198.49.126.79]:39814 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618AbZLAU7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 15:59:06 -0500
Date: Tue, 1 Dec 2009 13:59:10 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Grant Grundler <grundler@parisc-linux.org>,
       Alex Williamson <alex.williamson@hp.com>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] PCI: Always set prefetchable base/limit upper32
	registers
Message-ID: <20091201205910.GB16534@lackof.org>
References: <20091130214954.10845.23072.stgit@debian.lart> <20091201000332.GD24539@lackof.org> <20091201001942.GF24539@lackof.org> <1259640654.10482.44.camel@2710p.home> <20091201195523.GA16534@lackof.org> <4B157F23.4040701@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B157F23.4040701@kernel.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 01, 2009 at 12:40:03PM -0800, Yinghai Lu wrote:
...
> > I assumed Yinghai's objection was based on a specific problem he had
> > seen with writing upper32 register. Bjorn asked the right question.
> > If there isn't a specific problem, I'd prefer AW's simpler patch.
> 
> we just should not touch that register if the HW only support 32bit pref mmio.

Why not?

I agree the PCI-PCI spec defines how to determine if a PCI Bridge supports
64-bit Pref MMIO (using upper32 - or not). But spec also doesn't prohibit
writing to a read-only register.  Writing this Read-Only register so far
hasn't caused any problems.

> > I'm also thinking the resource allocation design which uses resource
> > flags to indicate resources assigned (e.g a resource is 32-bit) rather
> > than HW attributes is broken. We should be able to allocate 32-bit Option
> > ROM into a 64-bit prefetchable MMIO window that is programmed with upper32
> > as zeros without changing the resource type. The resource allocation
> > code only be looking at Resource "Type" when (re)programming
> > window registers. The rest of the time (programming BARs) should be
> > able to just test "if it fits".
> 
> IORESOURCE_MEM_64 is the flags that the resource could be assigned to >4g range.
> so it is NOT assigned resource ...

*shrug* I don't have time to work on the broader issue.

thanks,
grant
