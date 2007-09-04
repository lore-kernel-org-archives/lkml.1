Return-Path: <linux-kernel-owner+w=401wt.eu-S1752665AbXIDGRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbXIDGRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 02:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbXIDGRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 02:17:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37380 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbXIDGRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 02:17:32 -0400
Message-ID: <46DCF84F.1010302@zytor.com>
Date: Tue, 04 Sep 2007 07:16:47 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Christian Ehrhardt <lk@c--e.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: New x86-Setup code breaks HVM-XEN boot
References: <20070830141528.GA307@lisa.in-ulm.de> <46D6D8F6.2040201@zytor.com> <20070903183237.GA1208@genua.de>
In-Reply-To: <20070903183237.GA1208@genua.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Ehrhardt wrote:
> 
> I took the trouble to bisect (manually) exactly which change in the new
> boot code triggers this problem.
> 
> The problem is with the lgdt instruction. Apparently XEN does not keep
> the contents of the 48-bit gdt_48 data structure that is passed to lgdt
> in the XEN machine state. Instead it appears to save the _address_ of the
> 48-bit descriptor somewhere. Unfortunately this data happens to reside on the
> stack and is probably no longer availiable at the time of the actual
> protected mode jump.
> 
> This is most likely a XEN-bug but given that there is a on line patch
> to work around this problem, the linux kernel should probably do this.
> My fix is to make the gdt_48 description in setup_gdt static (in
> setup_idt this is already the case). This allows the kernel to boot under
> XEN-hvm again.

Would indeed be a Xen bug, and a pretty serious one too.  Quite frankly, 
it reflects some pretty fundamental misconceptions about how x86 works.

> 
> Sometimes it is a bit disappointing if quite some debuggin work results
> in a on line patch :-) Pleae consider applying.
> 

LOL, well, that's usually a good thing.

	-hpa

