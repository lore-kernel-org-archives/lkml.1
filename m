Return-Path: <linux-kernel-owner+w=401wt.eu-S1756459AbZALVln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459AbZALVln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 16:41:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbZALVle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 16:41:34 -0500
Received: from gate.crashing.org ([63.228.1.57]:40300 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbZALVld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 16:41:33 -0500
Subject: Re: can't mmap PCI legacy_mem on Powerbook G4
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Daniel Drake <dsd@gentoo.org>
Cc: linux kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       dliana@frontiernet.net
In-Reply-To: <496B2983.2030601@gentoo.org>
References: <496B2983.2030601@gentoo.org>
Content-Type: text/plain
Date: Tue, 13 Jan 2009 08:41:09 +1100
Message-Id: <1231796469.22571.33.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-12 at 11:29 +0000, Daniel Drake wrote:
> Hi,
> 
> Dave reports a 2.6.28 regression here:
> https://bugs.gentoo.org/show_bug.cgi?id=253149
> 
> X (server v1.5.3) no longer starts, it aborts with a mmap() error.
> 
> 
> This is because X tries to use sysfs pci legacy_mem to map the VGA frame 
> buffer if it is available, and this became available in 2.6.28 for ppc, 
> but the mmap() fails with -ENXIO.

Argh... Can the X folks stop being full of sh*t ? I'll have to have a
look there, fortunately, I'm occasionally one of them :-)

I made the files available on all powerpc, however, not all platforms
support legacy mem access. The PowerBook doesn't, which is why it
returns the error. It would be more complicated to make the file's
existence conditional instead, but I'll loo kat it.

In the meantime, please file an X bug. It shouldn't fallback to /proc or
whatever junk it did with /dev/mem, it should understand that as "the
kernel supports the legacy interfaces, and tells you this machine has no
access to legacy mem" and thus disable all attempts at whacking VGA text
mode.

Ben.


