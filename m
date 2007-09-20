Return-Path: <linux-kernel-owner+w=401wt.eu-S1759034AbXITGoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034AbXITGoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 02:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbXITGoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 02:44:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43189 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750862AbXITGoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 02:44:16 -0400
Date: Wed, 19 Sep 2007 23:44:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Olaf Hering <olaf@aepfle.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] increase AT_VECTOR_SIZE to terminate saved_auxv
 properly
Message-Id: <20070919234411.d5bf33ea.akpm@linux-foundation.org>
In-Reply-To: <20070918115504.GA609@aepfle.de>
References: <20070914110057.GA10088@aepfle.de>
	<20070918115504.GA609@aepfle.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 13:55:04 +0200 Olaf Hering <olaf@aepfle.de> wrote:

> include/asm-powerpc/elf.h has 6 entries in ARCH_DLINFO.
> fs/binfmt_elf.c has 14 unconditional NEW_AUX_ENT entries and 2
> conditional NEW_AUX_ENT entries.
> So in the worst case, saved_auxv does not get an AT_NULL entry at the
> end.
> 
> The saved_auxv array must be terminated with an AT_NULL entry.
> Make the size of mm_struct->saved_auxv arch dependend,
> based on the number of ARCH_DLINFO entries.

I'm not very confident that this will work well with the
already-queued move-mm_struct-and-vm_area_struct.patch.

It moves the saved_auxv[AT_VECTOR_SIZE] definition over into
mm_types.h and mm_types.h doesn't include sched.h.
