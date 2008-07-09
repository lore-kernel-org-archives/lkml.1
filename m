Return-Path: <linux-kernel-owner+w=401wt.eu-S1753491AbYGIQhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbYGIQhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 12:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbYGIQhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 12:37:25 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:56564 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbYGIQhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 12:37:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DLlcQ/TOcaIJLbKP7VBZrGFNB+O8uE5b2noLyLaKU+4o348YiCIAPXVTqTX8RPy05a
         BKKxHbnSY8f+PDumX4EJ38I6OTk9qwMVsZyJjGeTadgVUx+ynl++XLalw3+EOfE3mI4q
         QitWOmvx+Rfm+s/tpYPAbJXZG+mHGwjXoBZks=
Date: Wed, 9 Jul 2008 18:36:32 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25: random stalls on certain hardware - regression?
Message-ID: <20080709163618.GA5462@joi>
References: <4873E27C.6050504@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4873E27C.6050504@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 01:56:12AM +0400, Michael Tokarev wrote:
> No hope to resolve this but still - maybe someone has an idea...
>
> Hardware is -
>  AMD Athlon x2-64 system
>  Asus M2N-SLI DELUXE motherboard (nvidia MCP55)
>  AMD BE-2400 CPU
>  2x 2Gb mem
>  Adaptec 3950B Ultra2 SCSI adapter (*)
>  4x 36Gb Seagate SCSI disks
>  2x nvidia GbE ethernet
>  rtl8139 nic as 3rd one
>
> When booting 2.6.25 - either 32 or 64 bits - the system freezes/hangs
> at some random point.  So far there was about 10 hangs, some after
> several minutes after boot, some are within hours.
>
> The "hang" is a complete system freeze - on the console there's
> still "... login:" prompt, but nothing works - keyboard is stuck
> (numlock doesn't work), and server is not responding over network.
> Sometimes ping to the server itself works, but definitely not routing.
> (it's a server so no fancy stuff is loaded - X isn't even installed).
>
> The kernel is vanilla 2.6.25 - tried several - .5, .8, .10 now -
> the effect is the same.
>
> 2.6.24 and before worked without any glitch (2.6.24 is currently
> running).  We tried different versions of BIOS (was 12something
> before, tried 1304 and - currently - 1405, since 1502 is still
> beta) - no difference at all.
>
> The problem is that it is a production machine, and quite some
> people depend on it (it's a remote office with only one server),
> so I've very limited ability to try something.  Unfortunately not
> git bisect, -- or at least I'm afraid to try it, both because of
> possibility to have many reboots AND new freezes, and because
> unstable kernel (2.6.25pre stuff) with possibility to break something.

Definitely try 2.6.26-rc9 (which will soon become 2.6.26, so people will
probably ask you to test patches on top of this kernel) and if it will still 
lock up, take a look at Documentation/nmi_watchdog.txt and maybe
Documentation/networking/netconsole.txt in kernel sources.

Marcin
