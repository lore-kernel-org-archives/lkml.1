Return-Path: <linux-kernel-owner+w=401wt.eu-S932199AbXBNKoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbXBNKoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 05:44:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932200AbXBNKoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 05:44:04 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:36547 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199AbXBNKoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 05:44:02 -0500
Date: Wed, 14 Feb 2007 16:13:39 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: kraxel@suse.de, Andi Kleen <ak@muc.de>
Subject: Will smp alternative try to patch init text also?
Message-ID: <20070214104338.GA3393@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just built a 2.6.20 kernel with CONFIG_RELOCATABLE=y. While going
through relocation entries for .smp_locks section, I see some relocation
entries present w.r.t to init section also. Below I am pasting just
few of them.

Relocation section '.rel.smp_locks' at offset 0x6079c8 contains 4662 entries:
 Offset     Info    Type            Sym.Value  Sym. Name
c058e000  00001201 R_386_32          c0593000   .init.text
c058e004  00001201 R_386_32          c0593000   .init.text
c058e008  00001201 R_386_32          c0593000   .init.text

So what happens if somebody builds a SMP kernel and runs on a UP machine.
Later it hotplus one CPU. Then kernel will switch to SMP mode. Looking
at the code it looks like it will also try to patch init text which is
no more there and will corrupt something else? 

Am I missing something?

MODPOST whitelists the references from .smp_locks section to .init.text,
hence these warnings are not displayed during compilation.

Thanks
Vivek
