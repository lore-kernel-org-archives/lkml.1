Return-Path: <linux-kernel-owner+w=401wt.eu-S1754277AbZFZWGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbZFZWGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 18:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbZFZWGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 18:06:38 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:45576 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbZFZWGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 18:06:37 -0400
Date: Sat, 27 Jun 2009 00:08:58 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       devel@ksplice.com, Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH 0/2] Macros for section name cleanup
Message-ID: <20090626220858.GB26451@uranus.ravnborg.org>
References: <1245801452-13222-1-git-send-email-tabbott@ksplice.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245801452-13222-1-git-send-email-tabbott@ksplice.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 07:57:30PM -0400, Tim Abbott wrote:
> These are the remaining changes from my previous macros for section
> name cleanup patch series that were not subsumed by Sam Ravnborg's
> recent update to vmlinux.lds.h (commit
> 7923f90fffa8746f6457d4eea2109fd3d6414189).
> 
> I've dropped the patch reworking __read_mostly to be a generic thing
> in include/linux/cache.h.  I think the consensus on that patch was
> that we should first make all the architectures support
> .data.read_mostly in their linker scripts and then do a single patch
> removing all the architecture implementations in favor of a single one
> in include/linux/cache.h.
> 
> The long-term goal here is to add support for building the kernel with
> -ffunction-sections -fdata-sections.  This requires renaming all the
> magic section names in the kernel of the form .text.foo, .data.foo,
> .bss.foo, and .rodata.foo to not have collisions with sections
> generated for code like:
> 
> static int nosave = 0; /* -fdata-sections places in .data.nosave */
> static void head(); /* -ffunction-sections places in .text.head */
> 
> Sam Ravnborg proposed that rather than just renaming all the sections
> outright, we should start by first getting more control over the
> section names used in the kernel so that we can later rename sections
> without touching too many files.  This patch series provides the
> architecture-independent macros needed for that cleanup.
> 
> Tim Abbott (2):
>   Add new macros for page-aligned data and bss sections.
>   Add new __init_task_data macro to be used in arch init_task.c files.

Applied all thre patches from you - replacing one from Jesper Nilsson
with the one from you.

	Sam
