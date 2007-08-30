Return-Path: <linux-kernel-owner+w=401wt.eu-S1762980AbXH3VlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762980AbXH3VlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 17:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760439AbXH3VlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 17:41:13 -0400
Received: from mail.gmx.net ([213.165.64.20]:44178 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758131AbXH3VlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 17:41:12 -0400
X-Authenticated: #12383568
X-Provags-ID: V01U2FsdGVkX18Afp1GTXAA2omYR3A+EuTHE/ZdazlYMuyWZv5zzC
	OFxnc5CeEbwJTm
From: Clemens Kolbitsch <clemens.kol@gmx.at>
To: linux-kernel@vger.kernel.org
Subject: Re: Forbid deletion of memory mappings
Date: Thu, 30 Aug 2007 23:41:09 +0200
User-Agent: KMail/1.9.6
References: <200708301844.10532.clemens.kol@gmx.at> <200708302332.42744.clemens.kol@gmx.at> <Pine.LNX.4.64.0708302333320.2460@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0708302333320.2460@twin.jikos.cz>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200708302341.09459.clemens.kol@gmx.at>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 August 2007 23:34:52 you wrote:
> On Thu, 30 Aug 2007, Clemens Kolbitsch wrote:
> > is there no way to tell the kernel, that a certain mapping must not be
> > removed, no matter what (except of course an explicit call to sys_unmap,
> > of course)?
>
> I don't seem to get what is the issue here. Your mapping is not removed,
> only the VMAs are merged together into one larger VMA if they have
> neighbouring address ranges and compatible protection bits. See
> vma_merge().

the thing is that they are not. the kernel chooses to REPLACE my mapping.

consider the user-space code:

mmap(0xaaaa0000, 0x3000, MAP_FIXED, ...);
mmap(0xaaaa1000, 0x4000, MAP_FIXED, ...);

here, the second call to mmap will shorten the first mapping to 0x1000 bytes 
and create one big vma with size 0x5000 bytes.

is there a way to tell it that the second mmap MUST fail?


