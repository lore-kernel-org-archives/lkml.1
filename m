Return-Path: <linux-kernel-owner+w=401wt.eu-S934368AbYAaQxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934368AbYAaQxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 11:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934207AbYAaQxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 11:53:07 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:58607 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934198AbYAaQxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 11:53:05 -0500
Date: Thu, 31 Jan 2008 17:53:04 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Arjan van de Ven <arjan@infradead.org>
cc: linux-kernel@vger.kernel.org, davej@redhat.com, mingo@elte.hu,
       tglx@tglx.de, hpa@zytor.com
Subject: Re: [PATCH] x86: introduce /dev/mem restrictions with a config option
In-Reply-To: <20080130124853.184ef782@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0801311729190.4864@fbirervta.pbzchgretzou.qr>
References: <20080130124853.184ef782@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 30 2008 12:48, Arjan van de Ven wrote:
>Subject: [PATCH] x86: introduce /dev/mem restrictions with a config option
>
>This patch introduces a restriction on /dev/mem: Only non-memory can be
>read or written unless the newly introduced config option is set.

Would not it be nicer to add a /dev/pcimem that implements the given 
restrictive semantics?

Maybe it's just wishful thinking, but I am dreaming of an unprivileged 
X, and /dev/pcimem (owned by an 'x11' user or so) would be a step in 
that direction.

>The X server needs access to /dev/mem for the PCI space, but it doesn't need
>access to memory; both the file permissions and SELinux permissions of /dev/mem
>just make X effectively super-super powerful. With the exception of the
>BIOS area, there's just no valid app that uses /dev/mem on actual memory.

And so I could even get rid of /dev/mem.

>People who want to use /dev/mem for kernel debugging can enable the config
>option.

With a pcimem, kernel people would not need to reconfig the kernel, just 
create/delete the node as they wish.
