Return-Path: <linux-kernel-owner+w=401wt.eu-S1758353AbXGWGCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353AbXGWGCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 02:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbXGWGB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 02:01:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901AbXGWGB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 02:01:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: David Miller <davem@davemloft.net>
X-Fcc: ~/Mail/linus
Cc: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: "build-id" changes break sparc64
In-Reply-To: David Miller's message of  Sunday, 22 July 2007 01:23:21 -0700 <20070722.012321.79430375.davem@davemloft.net>
X-Shopping-List: (1) Uninteresting configuration ashes
   (2) Omniscient pancakes
   (3) Inelegant samples
Message-Id: <20070723060155.2B3824D0489@magilla.localdomain>
Date: Sun, 22 Jul 2007 23:01:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It turns out the problem here is that some .o files wind up with their own
.note.gnu.build-id sections.  I got the makefile magic wrong, thinking that
LDFLAGS_MODULE was a variable specifically for .ko links.  It's also used
in cmd_link_multi-m.  So the problem David and Adrian saw is not actually
machine-dependent at all, nor is it an ld bug as I had guessed, but depends
on the configuration details that determine when cmd_link_multi-m gets used.

I'll post a makefile fix shortly.


Thanks,
Roland
