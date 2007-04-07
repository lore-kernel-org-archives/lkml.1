Return-Path: <linux-kernel-owner+w=401wt.eu-S965662AbXDGJOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965662AbXDGJOK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 05:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965679AbXDGJOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 05:14:10 -0400
Received: from smtp.osdl.org ([65.172.181.24]:48696 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965662AbXDGJOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 05:14:08 -0400
Date: Sat, 7 Apr 2007 02:14:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/4] clean up identify_cpu
Message-Id: <20070407021401.a993892b.akpm@linux-foundation.org>
In-Reply-To: <20070406224204.782242327@goop.org>
References: <20070406224152.556848893@goop.org>
	<20070406224204.782242327@goop.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Apr 2007 15:41:54 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> identify_cpu() is used to identify both the boot CPU and secondary
> CPUs, but it performs some actions which only apply to the boot CPU.
> Those functions are therefore really __init functions, but because
> they're called by identify_cpu(), they must be marked __cpuinit.
> 
> This patch splits identify_cpu() into identify_boot_cpu() and
> identify_secondary_cpu(), and calls the appropriate init functions
> from each.  Also, identify_boot_cpu() and all the functions it
> dominates are marked __init.

x86_64 uses this too.

WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.text:mtrr_bp_init from .text.identify_cpu after 'identify_cpu' (at offset 0x655)
