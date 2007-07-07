Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbXGGUoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbXGGUoH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 16:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbXGGUn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 16:43:56 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:56859 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbXGGUnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 16:43:55 -0400
To: pavel@ucw.cz
CC: miklos@szeredi.hu, oliver@neukum.org, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
In-reply-to: <20070707121729.GC3111@elf.ucw.cz> (message from Pavel Machek on
	Sat, 7 Jul 2007 14:17:29 +0200)
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <Pine.LNX.4.44L0.0707041045150.25704-100000@netrider.rowland.org> <18060.14856.824473.325660@cargo.ozlabs.ibm.com> <200707050858.03638.oliver@neukum.org> <E1I6MWb-0008Tq-00@dorka.pomaz.szeredi.hu> <20070705091801.GB3084@elf.ucw.cz> <E1I6NgZ-0000F6-00@dorka.pomaz.szeredi.hu> <20070705115400.GF3984@ucw.cz> <E1I6Q73-0000Xi-00@dorka.pomaz.szeredi.hu> <20070707121729.GC3111@elf.ucw.cz>
Message-Id: <E1I7H6v-0006pf-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 07 Jul 2007 22:42:33 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> We can just wait for all fuse requests to be serviced before
> proceeding further with freeze, right?

Right.  Nice way to slow down or stop the suspend with an unprivileged
process.  Avoiding that sort of DoS is one of the design goals of
fuse.

Look at it this way: the task of the freezer is to stop new I/O
hitting the hardware.  But it is totally indiscriminate about what it
stops, it tries to stop _everything_ even things which have nothing to
do with hardware.

Not nice.

Miklos
