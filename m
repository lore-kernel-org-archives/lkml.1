Return-Path: <linux-kernel-owner+w=401wt.eu-S1753174AbXE2VzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbXE2VzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 17:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbXE2VzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 17:55:05 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:45551 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbXE2VzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 17:55:03 -0400
Date: Tue, 29 May 2007 17:55:01 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: akpm@linux-foundation.org
Cc: wcohen@redhat.com, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, ralf@linux-mips.org
Subject: reduce-size-of-task_struct-on-64-bit-machines.patch removed from -mm tree
Message-ID: <20070529215501.GA15944@fattire.cabal.ca>
References: <200705090244.l492i4kH008542@shell0.pdx.osdl.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705090244.l492i4kH008542@shell0.pdx.osdl.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 07:44:04PM -0700, akpm@linux-foundation.org wrote:
> -	unsigned long flags;	/* per process flags, defined below */
> -	unsigned long ptrace;
> +	unsigned int flags;	/* per process flags, defined below */
> +	unsigned int ptrace;
>  

So.

I realize I don't have much right to cry over spilled milk here, seeing
as this has been floating around for, what, four months now?

But seriously, if people are going to fuck around with extremely core
pieces of generic code, could they please check all the users[1]?

Other 64-bit arch maintainers should check that they're using a 32-bit
load/store on these fields in their assembly now (we were using a
#define to do word on 32bit and doubleword on 64bit, which broke, badly,
when these changed.)

Thanks,
	Kyle M.

1: Adding __deprecated or something to the field would give you an idea
of where it is used, in this case asm-offsets.c...
