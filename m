Return-Path: <linux-kernel-owner+w=401wt.eu-S1753616AbXDKSeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbXDKSeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 14:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbXDKSeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 14:34:07 -0400
Received: from mail.suse.de ([195.135.220.2]:36134 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616AbXDKSeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 14:34:04 -0400
Date: Wed, 11 Apr 2007 20:33:38 +0200
From: Olaf Dabrunz <od@suse.de>
To: John Stoffel <john@stoffel.org>
Cc: Gerd Hoffmann <kraxel@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>, Ralf Baechle <ralf@linux-mips.org>,
       Andi Kleen <ak@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch v2] Fixes and cleanups for earlyprintk aka boot console.
Message-ID: <20070411183338.GB29059@suse.de>
Mail-Followup-To: John Stoffel <john@stoffel.org>,
	Gerd Hoffmann <kraxel@suse.de>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Mundt <lethal@linux-sh.org>, Ralf Baechle <ralf@linux-mips.org>,
	Andi Kleen <ak@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Richard Henderson <rth@twiddle.net>,
	Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
	Paul Mackerras <paulus@samba.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>
References: <20070315154638.944768000@suse.de> <17913.45970.178029.519745@smtp.charter.net> <20070329163714.GA29059@suse.de> <17938.30190.281832.393043@smtp.charter.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <17938.30190.281832.393043@smtp.charter.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03-Apr-07, John Stoffel wrote:
> 
> Sorry, I've been away for the past 10+ days and not reading email at
> all.  

NP. Happens to me too (as you can see).

> Olaf> Try changing the order of the console= parameters:
> 
> Olaf>     kernel ... console=ttyS1,96008N1 console=tty0
> 
> This isn't good for me, since it then drops some output I want to save
> via the serial console to the regular console.  It would be nice if
> all output went to BOTH consoles, though input should only be accepted
> on the first console listed.  

That is actually the underlying problem: the Linux kernel does not
provide the means to duplicate data streams in the kernel to several
devices. This has to be done in user-space. The main reason for this is
that error handling, locking and such things would need to be different
if streams had a fan-in or a fan-out. It tends to make things more
complicated.

But probably it is an interesting project to explore and define the
sematics of devices with fan-in and fan-out.

I can image that user-space programs would be able to add fan-in or
fan-out file-descriptors to an opened file-descriptor by using an
ioctl(), but then they would need to be prepared to deal with different
error handling and behaviour of such a "file".

Some devices (as the console device) could then have a pre-defined
fan-in or fan-out set by default, if opened with a special flag. A
program using this flag would then say: I am prepared to deal with
fan-in / fan-out semantics.

-- 
Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, Nürnberg

