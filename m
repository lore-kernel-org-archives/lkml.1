Return-Path: <linux-kernel-owner+w=401wt.eu-S1765507AbXEYVXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765507AbXEYVXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 17:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbXEYVW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 17:22:59 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:46122 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753391AbXEYVW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 17:22:59 -0400
Date: Fri, 25 May 2007 23:22:57 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Arnd Bergmann <arnd@arndb.de>
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 5/7] ps3: Disk Storage Driver
In-Reply-To: <200705252243.41508.arnd@arndb.de>
Message-ID: <Pine.LNX.4.62.0705252318160.2657@pademelon.sonytel.be>
References: <20070525083607.784351000@sonycom.com> <200705251826.25572.arnd@arndb.de>
 <Pine.LNX.4.62.0705252137230.2657@pademelon.sonytel.be> <200705252243.41508.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007, Arnd Bergmann wrote:
> On Friday 25 May 2007, Geert Uytterhoeven wrote:
> > > I don't really understand what the kthread is needed for. You probably
> > > thought about multiple options and ended up with this, but having
> > > a comment in front of it might be helpful.
> > 
> > I used a kthread because the request function of a block device driver must be
> > non-blocking, and ps3stor_read_write_sectors() calls wait_for_completion().
> 
> Ok, but why does it call wait_for_completion() then?
> I thought you could end_that_request_* from the interrupt handler instead.

Actually I tried that first, but I ran into other problems, like my request
handler being called continuously and requests gotten stuck. But maybe it was
just a locking bug on my side.

I can retry, but a disadvantage will be that there will be less code shared
with ps3flash and ps3rom.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
