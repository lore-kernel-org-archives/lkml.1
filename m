Return-Path: <linux-kernel-owner+w=401wt.eu-S1762845AbYHEQ53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762845AbYHEQ53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 12:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761282AbYHEQzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 12:55:33 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4247 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757017AbYHEQz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 12:55:29 -0400
Date: Tue, 5 Aug 2008 14:15:56 +0200
From: Pavel Machek <pavel@suse.cz>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 20/62] x86, suspend, acpi: enter Big Real Mode
Message-ID: <20080805121556.GA7426@ucw.cz>
References: <20080730233050.332789722@mini.kroah.org> <20080730235831.GT12896@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730235831.GT12896@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-07-30 16:58:31, Greg KH wrote:
> 2.6.26 -stable review patch.  If anyone has any objections, please let
> us know.
> 
> ------------------
> From: H. Peter Anvin <hpa@zytor.com>
> 
> Commit 3bf2e77453a87c22eb57ed4926760ac131c84459 upstream
> 
> x86, suspend, acpi: enter Big Real Mode
> 
> The explanation for recent video BIOS suspend quirk failures is that
> the VESA BIOS expects to be entered in Big Real Mode (*.limit = 0xffffffff)
> instead of ordinary Real Mode (*.limit = 0xffff).
> 
> This patch changes the segment descriptors to Big Real Mode instead.
> 
> The segment descriptor registers (what Intel calls "segment cache") is
> always active.  The only thing that changes based on CR0.PE is how it is
> *loaded* and the interpretation of the CS flags.
> 
> The segment descriptor registers contain of the following sub-registers:
> selector (the "visible" part), base, limit and flags.  In protected mode
> or long mode, they are loaded from descriptors (or fs.base or gs.base can
> be manipulated directly in long mode.)  In real mode, the only thing
> changed by a segment register load is the selector and the base, where the
> base <- selector << 4.  In particular, *the limit and the flags are not
> changed*.
> 
> As far as the handling of the CS flags: a code segment cannot be writable
> in protected mode, whereas it is "just another segment" in real mode, so
> there is some kind of quirk that kicks in for this when CR0.PE <- 0.  I'm
> not sure if this is accomplished by actually changing the cs.flags register
> or just changing the interpretation; it might be something that is
> CPU-specific.  In particular, the Transmeta CPUs had an explicit "CS is
> writable if you're in real mode" override, so even if you had loaded CS
> with an execute-only segment it'd be writable (but not readable!) on return
> to real mode.  I'm not at all sure if that is how other CPUs behave.
> 
> Signed-off-by: "H. Peter Anvin" <hpa@zytor.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
