Return-Path: <linux-kernel-owner+w=401wt.eu-S1755809AbXLGVVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809AbXLGVVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 16:21:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbXLGVVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 16:21:25 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1452 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753236AbXLGVVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 16:21:24 -0500
Date: Wed, 5 Dec 2007 11:10:39 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "David P. Reed" <dpreed@reed.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64 with MCP51 laptops
Message-ID: <20071205111039.GA3864@ucw.cz>
References: <475879CD.9080006@reed.com> <p733auekcly.fsf@bingen.suse.de> <47595DB2.5080302@reed.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47595DB2.5080302@reed.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2007-12-07 09:50:26, David P. Reed wrote:
> My machine in question, for example, needs no waiting 
> within CMOS_READs at all.   And I doubt any other 
> chip/device needs waiting that isn't already provided by 
> the bus. the i/o to port 80 is very, very odd in this 
> context.  Actually, modern machines have potentially 
> more serious problems with i/o ops to non-existent 
> addresses, which may cause real bus wierdness.

I dislike outb_p clobbering port 0x80, but you are wrong here. BIOSes
already do outs to port 0x80 for debugging reason, so these accesses
are unlikely to do something bad.

Can we just do udelay(1) instead of port 80 access?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
