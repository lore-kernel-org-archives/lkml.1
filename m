Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbYFTSkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbYFTSkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 14:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbYFTSkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 14:40:39 -0400
Received: from gw.goop.org ([64.81.55.164]:48591 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbYFTSki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 14:40:38 -0400
Message-ID: <485BF9A4.8090404@goop.org>
Date: Fri, 20 Jun 2008 11:40:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com> <20080604003019.509483000@polaris-admin.engr.sgi.com> <20080605102222.GA21319@elte.hu> <484EF29C.7080100@sgi.com> <485947A8.8060801@goop.org> <4859511E.5050605@sgi.com> <48596315.6020104@goop.org> <48596893.4040908@sgi.com> <485AADAC.3070301@sgi.com> <485AB78B.5090904@goop.org> <485AC120.6010202@sgi.com> <485AC5D4.6040302@goop.org> <485ACA8F.10006@sgi.com> <485ACD92.8050109@sgi.com> <485AD138.4010404@goop.org> <485ADA12.5010505@sgi.com> <485ADC73.60009@goop.org> <485BDB04.4090709@sgi.com> <485BE80E.10209@goop.org> <Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com> <485BF73C.7010802@sgi.com>
In-Reply-To: <485BF73C.7010802@sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Yes, it is... The fixup logic is this:
>
> 0000000000004000 D per_cpu__gdt_page
> ffffffff81911000 A __per_cpu_load
>
> arch/x86/kernel/cpu/common.c:
>
> DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
>         [GDT_ENTRY_KERNEL_CS] = { { { 0x0000ffff, 0x00cf9a00 } } },
>   

Aha, you fell into the trap!  "common" in this case means "common to 
32-bit x86".  Or something.  But setup_64.c is what you want to be 
looking at.

    J
