Return-Path: <linux-kernel-owner+w=401wt.eu-S932785AbXGRABG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785AbXGRABG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 20:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937330AbXGRAAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 20:00:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38001 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762997AbXGRAAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 20:00:48 -0400
Date: Wed, 18 Jul 2007 01:00:45 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Ben Dooks <ben@fluff.org>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, avi@qumranet.com
Subject: Re: [PATCH] smp_call_function_single() should be a macro on UP
Message-ID: <20070718000045.GR21668@ftp.linux.org.uk>
References: <20070717212946.GP21668@ftp.linux.org.uk> <20070717.144042.41636155.davem@davemloft.net> <20070717235417.GA18459@fluff.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070717235417.GA18459@fluff.org.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 12:54:17AM +0100, Ben Dooks wrote:
> This has broken _all_ ARM builds, due to using WARN_ON()
> in this header. Warn on needs <asm/bug.h> and this is
> needs <linux/kernel.h> to make it compile cleanly on ARM
> which is unfortuantely what we where trying to avoid in
> the first place?
> 
> This patch fixes the compile on ARM, but moves the
> includes out of the CONFIG_SMP block.

Which "this" are you refering to?  Original introduction of inline
or switch to a macro on top of it?

FWIW, with "turn to macro" all arm builds I have here pass fine.
Please, check if current Linus' tree (already with that patch)
works for you; I very much object to pulling more includes in
there, that way lies a lot of breakage.
