Return-Path: <linux-kernel-owner+w=401wt.eu-S1423148AbXD3IQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423148AbXD3IQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 04:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423157AbXD3IQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 04:16:54 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33898 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423148AbXD3IQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 04:16:53 -0400
Date: Mon, 30 Apr 2007 09:17:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Chinner <dgc@sgi.com>
Cc: Zan Lynx <zlynx@acm.org>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [-mm patch] i386: enable 4k stacks by default
Message-ID: <20070430091754.24df88df@the-village.bc.nu>
In-Reply-To: <20070430035838.GC77450368@melbourne.sgi.com>
References: <20070428191927.GN3468@stusta.de>
	<1177795118.7828.6.camel@localhost>
	<20070430035838.GC77450368@melbourne.sgi.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I doubt it.  Every time this comes up the problem of stacked I/O
> configuration being able to reliably blow the 4k stack limit comes
> up. Usually it's XFS that is blamed, but it seems ext3 and reiser
> can both suffer from the same problem.  And now we can add things
> like unionfs/ecryptfs into the stack as well....

The 8K stack selection does not change this, it just means that if there
is a problem it'll randomly blow up when the heavy IRQ user and the heavy
non-IRQ user occur at the right moments. If this still occurs for some
combinations then the fix would be 8K + 4K IRQ stack, not just to use 8K
stack

Alan
