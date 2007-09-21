Return-Path: <linux-kernel-owner+w=401wt.eu-S1764207AbXIUWGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764207AbXIUWGY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932110AbXIUWGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:06:13 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3993 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096AbXIUWGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:06:11 -0400
Subject: Re: [Announce] Linux-tiny project revival
From: Joe Perches <joe@perches.com>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Rob Landley <rob@landley.net>, Indan Zupancic <indan@nul.nu>,
       linux-tiny@selenic.com, Michael Opdenacker <michael@free-electrons.com>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4477DB43-766B-4057-B33D-357A73AF69B0@mac.com>
References: <46F1645D.9050406@am.sony.com>
	 <200709201538.43093.rob@landley.net>
	 <59465.81.207.0.53.1190323573.squirrel@secure.samage.net>
	 <200709201818.42125.rob@landley.net>
	 <4477DB43-766B-4057-B33D-357A73AF69B0@mac.com>
Content-Type: text/plain
Date: Fri, 21 Sep 2007 15:05:34 -0700
Message-Id: <1190412335.32660.55.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-21 at 17:34 -0400, Kyle Moffett wrote:
> With a bit more glue that would cause GCC to notice that for a given  
> qprintk_kmalloc the "qpk->type" is always zero because the level is  
> too high, and therefore it would optimize out *ALL* of the  
> _qprintk_kmalloc(), _qprintk(), and _qprintk_finish() calls.

A negative is that lockup conditions swallow partial messages.

Another approach that doesn't require any new buffering is:

id = printk_block_start();
printk_block(id, fmt, ...)
printk_block_end(id)

and have print_block output the id when multiple IDs are
concurrently issued.

This requires a trivial tool to post-process the log
when messages are interleaved.

