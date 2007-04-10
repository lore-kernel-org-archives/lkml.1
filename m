Return-Path: <linux-kernel-owner+w=401wt.eu-S965570AbXDJWQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965570AbXDJWQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965687AbXDJWQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:16:29 -0400
Received: from gw.goop.org ([64.81.55.164]:45943 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965570AbXDJWQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:16:28 -0400
Message-ID: <461C0CB4.9000407@goop.org>
Date: Tue, 10 Apr 2007 15:16:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Chris Wright <chrisw@sous-sol.org>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@muc.de>, Rusty Russell <rusty@rustcorp.com.au>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dan Hecht <dhecht@vmware.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 9/10] Vmi timer update.patch
References: <200704100006.l3A06RUR020644@zach-dev.vmware.com> <20070410023702.GJ10574@sequoia.sous-sol.org> <461BC373.10306@vmware.com> <20070410172429.GN10574@sequoia.sous-sol.org> <461C084C.9020009@vmware.com>
In-Reply-To: <461C084C.9020009@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
>        /*
>         * Avoid unnecessary state transitions, as it confuses
>         * Geode / Cyrix based boxen.
>         */
>        case CLOCK_EVT_MODE_SHUTDOWN:
>                if (evt->mode == CLOCK_EVT_MODE_UNUSED)
>                        break;
>        case CLOCK_EVT_MODE_UNUSED:
>                if (evt->mode == CLOCK_EVT_MODE_SHUTDOWN)
>                        break;
>        case CLOCK_EVT_MODE_ONESHOT:
>                /* One shot setup */
>                outb_p(0x38, PIT_MODE);
>
> So switching from PIT to VMI does not disable PIT timer interrupts. 
> Thus I have to keep this part of the patch.

Why not submit a patch to do what you need here?  (The Geode comment is
a bit worrying though.)

    J
