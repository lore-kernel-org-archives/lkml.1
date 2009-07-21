Return-Path: <linux-kernel-owner+w=401wt.eu-S1755639AbZGUQXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639AbZGUQXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755611AbZGUQXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:23:39 -0400
Received: from tango.0pointer.de ([85.214.72.216]:40943 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbZGUQXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:23:38 -0400
Date: Tue, 21 Jul 2009 18:23:12 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: add an event interface
Message-ID: <20090721162312.GA25151@tango.0pointer.de>
References: <20090702113529.4896.2321.stgit@t61.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090702113529.4896.2321.stgit@t61.ukuu.org.uk>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02.07.09 12:36, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:

(Sorry for the long delay in responding, I have been travelling)

> Lennart how does this fit your needs - this replaces the existing wait
> active hack with a race free one and adds other events with a proper
> infrastructure for them.

Sounds good to me. Though tbh, in my eyes the "proper" fix for this
whole problem would be something which would enable userspace to
poll() for VT changes. Having blocking ioctl()s still requires most
userspace applications to spawn a thread for doing that since usually
they are not exclusively waiting for VT events, but also for dbus
requests or some other events.

But OTOH I guess 2 threads are still better than the old situation
requiring processes to run 64 threads for listening for VT changes.

Oh, and one more note: instead of padding the struct it would probably
be more future-proof to simply pass the struct size in addition to the
struct to the ioctl().

Lennart

> From: Alan Cox <alan@linux.intel.com>
> 
> This is needed and requested in various forms for ConsoleKit, screenblank
> handling and the like so do the job with a single interface. Also build the
> interface so that unlike VT_WAITACTIVE and friends it won't miss events.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>

-- 
Lennart Poettering                        Red Hat, Inc.
lennart [at] poettering [dot] net
http://0pointer.net/lennart/           GnuPG 0x1A015CC4
