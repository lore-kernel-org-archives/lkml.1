Return-Path: <linux-kernel-owner+w=401wt.eu-S1757272AbXIEW1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbXIEW1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 18:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949AbXIEW1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 18:27:03 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39028 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbXIEW1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 18:27:00 -0400
Date: Thu, 6 Sep 2007 04:10:11 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Willy Tarreau <w@1wt.eu>
cc: Axel Reinhold <axel@freakout.de>,
       Richard Kojedzinszky <krichy@tvnetwork.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.4.35.1 and panic at boot with arch=c3 and gcc-4.x
In-Reply-To: <20070905220027.GB11602@1wt.eu>
Message-ID: <alpine.LFD.0.999.0709060404070.26804@enigma.security.iitk.ac.in>
References: <20070905220027.GB11602@1wt.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 6 Sep 2007, Willy Tarreau wrote:
> 
> I finally tracked the problem down to a dirty trick used to prevent
> do_test_wp_bit() from being inlined (Axel, you identified the right
> file). Unfortunately, this trick does not work anymore when gcc-4.x
> is used without -fno-unit-at-a-time, so let's use the correct method
> instead.
> 
>  
> -/* Put this after the callers, so that it cannot be inlined */
> -static int do_test_wp_bit(unsigned long vaddr)

Ick, that was horrible indeed!

> I really hope that this trick is not used anywhere else!

Me too ... funnily enough, 2.6.23-rc5 still has that wrong comment in it!
