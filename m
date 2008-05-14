Return-Path: <linux-kernel-owner+w=401wt.eu-S1760459AbYENICj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760459AbYENICj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 04:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbYENICP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 04:02:15 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:51202 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbYENICN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 04:02:13 -0400
Date: Wed, 14 May 2008 10:02:11 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux/m68k <linux-m68k@vger.kernel.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: m68k: main.c:(.init.text+0x730): undefined reference to `strlen'
Message-ID: <Pine.LNX.4.64.0805140958400.5778@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


M68k builds with current mainline fail with

    init/built-in.o: In function `kernel_init':
    main.c:(.init.text+0x730): undefined reference to `strlen'

Reverting commit e662e1cfd434aa234b72fbc781f1d70211cb785b

    Author: Cyrill Gorcunov <gorcunov@gmail.com>
    Date:   Mon May 12 14:02:22 2008 -0700

    init: don't lose initcall return values

    There is an ability to lose an initcall return value if it happened with irq
    disabled or imbalanced preemption (and if we debug initcall).

fixes the problem. My first guess is gcc is turning sizeof() into strlen()
again.

Sample build log available at
http://kisskb.ellerman.id.au/kisskb/buildresult/27596/

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
