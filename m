Return-Path: <linux-kernel-owner+w=401wt.eu-S1758255AbZE0XMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255AbZE0XMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756289AbZE0XMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:12:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:60127 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816AbZE0XMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:12:14 -0400
Message-ID: <4A1DC8B4.9060003@kernel.org>
Date: Thu, 28 May 2009 08:11:48 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Greg KH <greg@kroah.com>, Robert Hancock <hancockrwd@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-pci@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>, towerlexa@gmx.de,
       Daniel Ritz <daniel.ritz@gmx.ch>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [RFC PATCH] pccard: configure CLS on attach
References: <4A1BE904.8080302@kernel.org> <20090526142300.73d466d0@lxorguk.ukuu.org.uk> <4A1C7EF9.2030000@gmail.com> <4A1C8091.4050909@kernel.org> <4A1C86F5.1020603@jp.fujitsu.com> <4A1D40FD.5050102@kernel.org> <20090527140328.GG5816@parisc-linux.org>
In-Reply-To: <20090527140328.GG5816@parisc-linux.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 27 May 2009 23:11:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Matthew Wilcox wrote:
> On Wed, May 27, 2009 at 10:32:45PM +0900, Tejun Heo wrote:
>> THIS IS A RFC PATCH, SO NO SOB.  PLEASE DON'T APPLY YET.
> 
> This breaks CONFIG_PPC64, fwiw.  We'll want to stub out
> pci_set_cacheline_size() for the PCI_DISABLE_MWI case too.

Right, thanks for spotting it.

> I don't know what PPC machines have Cardbus slots, presumably some
> Macs do.  I don't know whether firmware takes care of configuring the
> Cacheline Size register for Cardbus hotplug or not.  So we may want to
> include pci_set_cacheline_size() in the !MWI build, or not.  Ben, Paul?

ppc64 is also missing PCI_CACHE_LINE_SIZE so pci_set_cacheline_size()
can't be built as-is.  BTW, on x86, pci_cache_line_size isn't
configured like other pci devices on many machines, which doesn't harm
correctness but still...  CLS being the same for all devices coming
down from the same root bridge, maybe we can do away with the current
logic and just take it from the upstream pci bridge?

Thanks.

-- 
tejun
