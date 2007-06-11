Return-Path: <linux-kernel-owner+w=401wt.eu-S1763679AbXFKIZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763679AbXFKIZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 04:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756584AbXFKIZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 04:25:16 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:59019 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756129AbXFKIZO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 04:25:14 -0400
Message-Id: <466D2337.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 11 Jun 2007 10:25:59 +0200
From: "Jan Beulich" <jbeulich@novell.com>
To: <sam@ravnborg.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: kbuild: fix section mismatch check for vmlinux
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>vmlinux does not contain relocation entries which is
>used by the section mismatch checks.
>Reported by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
>
>Use the individual objects as inputs to overcome
>this limitation.
>In modpost check the .o files and skip non-ELF files.
>
>Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

This still doesn't appear to catch all cases - since the checking logic works
on a per-module basis, references between the individual .o files aren't
being checked. A current instance where this is visible is x86-64's recently
added alloc_bootmem_high_node (non-__init, in arch/x86_64/mm/built-in.o)
calling __alloc_bootmem_core (__init, in mm/built-in.o). I suppose there's
no way around linking $(KBUILD_VMLINUX_OBJS) into vmlinux.o, and
checking that file instead.

Jan

