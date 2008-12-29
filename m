Return-Path: <linux-kernel-owner+w=401wt.eu-S1752663AbYL2QZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbYL2QZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 11:25:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbYL2QZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 11:25:47 -0500
Received: from hiauly1.hia.nrc.ca ([132.246.100.193]:4760 "EHLO
	hiauly1.hia.nrc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbYL2QZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 11:25:47 -0500
X-Greylist: delayed 659 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Dec 2008 11:25:47 EST
Subject: Re: [PATCH 2/2] parisc: fix module loading failure of large modules
To: deller@gmx.de (Helge Deller)
Date: Mon, 29 Dec 2008 11:14:46 -0500 (EST)
From: "John David Anglin" <dave@hiauly1.hia.nrc.ca>
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       kyle@mcmartin.ca, randolph@tausq.org, jmm@inutil.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org, deller@gmx.de
In-Reply-To: <4958DA54.8060003@gmx.de> from "Helge Deller" at Dec 29, 2008 03:10:28 pm
X-Mailer: ELM [version 2.4 PL25]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Message-Id: <20081229161446.C91EB4EDA@hiauly1.hia.nrc.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Helge,

> With this patch we now instead append individual PLT stub entries
> directly at the end of the code sections where the stubs are actually
> called. This reduces the distance between the PCREL location and the
> stub entry so that the relocations can be fulfilled.

GCC for PA-RISC assumes that the stubs will be placed before the code
section.  This is what HP-UX does.  It's also not possible to compute
the distance to the end of a function in GCC due to the way branch
shortening is done.  If the distance to the start of the code section
is too large, GCC outputs a long call.

If you can insert them before the code section where the stubs are
called, this will minimize the chance that a pc-relative call will
not reach its stub.

It is possible to put the stubs after the code section if you can ensure
the distance for each call isn't too large.  I believe GNU ld does some
consolidation of stub blocks.

Great patch!

Dave
-- 
J. David Anglin                                  dave.anglin@nrc-cnrc.gc.ca
National Research Council of Canada              (613) 990-0752 (FAX: 952-6602)
