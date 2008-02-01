Return-Path: <linux-kernel-owner+w=401wt.eu-S1762962AbYBBAH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762962AbYBBAH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762132AbYBBAHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:07:51 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52258 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758291AbYBBAHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:07:50 -0500
Date: Fri, 1 Feb 2008 23:15:12 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: x86/.../trampoline_64.S racy?
Message-ID: <20080201221512.GA13276@elf.ucw.cz>
References: <20080201220716.GA8597@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201220716.GA8597@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-02-01 23:07:16, Pavel Machek wrote:
> Hi!
> 
> I'm trying to reuse trampoline_64.S for wakeup from ACPI s3... but I'm
> getting some badness: If I insert delay loops into trampoline_64.S,
> machine fails to boot; but I already increased cpu bootup delay to 200
> seconds...
> 
> Is it possible that bootup is subtly racy somewhere?

No, I just missed another place with timeout:

                /*
                 * Wait 5s total for a response
                 */
                for (timeout = 0; timeout < 5000000; timeout++) {
                        if (cpu_isset(cpu, cpu_callin_map))
                                break;  /* It has booted */
                        udelay(100);
                }

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
