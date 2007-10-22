Return-Path: <linux-kernel-owner+w=401wt.eu-S1755750AbXJVS1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbXJVS1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbXJVS1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:27:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35166 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755270AbXJVS1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:27:15 -0400
Date: Mon, 22 Oct 2007 11:21:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Al Viro <viro@ftp.linux.org.uk>,
       torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/2] irq_flags_t: intro and core annotations
Message-Id: <20071022112110.105b8e11.akpm@linux-foundation.org>
In-Reply-To: <20071022152912.GA841@linux-mips.org>
References: <20071020235546.GB1825@martell.zuzino.mipt.ru>
	<20071021005418.GU8181@ftp.linux.org.uk>
	<20071021093042.GA2144@martell.zuzino.mipt.ru>
	<20071022152912.GA841@linux-mips.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007 16:29:12 +0100 Ralf Baechle <ralf@linux-mips.org> wrote:

> On Sun, Oct 21, 2007 at 01:30:42PM +0400, Alexey Dobriyan wrote:
> 
> > 			irq_flags_t
> > 	
> > New type for use with spin_lock_irqsave() and friends.
> 
> Talking about it, why did we ever require this to be a long anyway?  I could
> get away with a single bit for MIPS; the rest of this variable is pure
> bloat.  An abstract datatype could help finally fix this.
> 

Yes, it's always been ugly that we use unsigned long for this rather than
abstracting it properly.

However I'd prefer that we have some really good reason for introducing
irq_flags_t now.  Simply so that I don't needlessly spend the next two
years wrestling with literally thousands of convert-to-irq_flags_t patches
and having to type "please use irq_flags_t here" in hundreds of patch
reviews. (snivel, wimper)
