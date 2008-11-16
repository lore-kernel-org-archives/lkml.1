Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbYKPRDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbYKPRDb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 12:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYKPRDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 12:03:21 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58832 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751404AbYKPRDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 12:03:21 -0500
Date: Sun, 16 Nov 2008 17:03:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bernhard Walle <bwalle@suse.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       crash-utility@redhat.com
Subject: Re: Turn CONFIG_STRICT_DEVMEM in sysctl dev.mem.restricted
Message-ID: <20081116170306.5b3bc30a@lxorguk.ukuu.org.uk>
In-Reply-To: <20081116171139.0456b1b2@kopernikus.site>
References: <1226846868-9595-1-git-send-email-bwalle@suse.de>
	<20081116150756.3cece2de@lxorguk.ukuu.org.uk>
	<20081116162003.04267538@kopernikus.site>
	<20081116154541.1f196f1e@lxorguk.ukuu.org.uk>
	<20081116171139.0456b1b2@kopernikus.site>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Which also doesn't explain what this turd is for.
> 
> Could we discuss more factual without words like "turd", please?

What else would you have me call it. It's junk.

> > The functionality provided by STRICT_DEVMEM is the same with it on or off
> > - absolutely *nothing*.
> 
> Even with SELinux?

As far as I can tell yes, and certainly with vendor shipped rulesets.

> > does compile it *out* and the overhead is gone totally for the many
> > embedded and other devices that don't use it.
> 
> For SELinux, yes. 

And for strict devmem but only before your patch.

> Oh well, I don't tell it our legal people if you would write SuSE
> instead of SUSE. Even not S.u.S.E. ;-)

Hehe ;)

> Well, if you let the CONFIG option there and only add the sysfs entry
> it does not. Even most embedded stuff is not x86.

These days a large amount of embedded is x86 and this is growing.

> > Even if you want to turd polish there are cleaner solutions. A process
> > with CAP_SYS_RAWIO can cheerfully bypass any restriction you try and
> > place so you could rip out all the sysctl crap and just say that
> > the /dev/mem restriction doesn't apply to a CAP_SYS_RAWIO process.
> 
> According to Arjan that does not work.

According to me CONFIG_STRICT_DEVMEM does not work either. Looking at the
X code most of it now tries really hard to use the right device files and
accesses. The window that is left is primarily the old ISA VGA hole and
even that could better be solved with a /dev/vgamem or similar that X
could use rather than /dev/mem.

Alan
