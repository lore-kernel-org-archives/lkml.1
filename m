Return-Path: <linux-kernel-owner+w=401wt.eu-S1752503AbZAZQX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbZAZQX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 11:23:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbZAZQXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 11:23:20 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:37268 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbZAZQXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 11:23:20 -0500
Date: Mon, 26 Jan 2009 17:23:03 +0100
From: Arjan Opmeer <arjan@opmeer.net>
To: Andy Whitcroft <apw@canonical.com>
Cc: patrakov@gmail.com, dmitry.torokhov@gmail.com,
       linux-kernel@vger.kernel.org
Message-ID: <20090126162303.GA11618@adopmeer.homeip.net>
References: <20090126150821.GC31179@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126150821.GC31179@shadowen.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Subject: Re: elantech touchpad driver miss-recognising logitech mice
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, Jan 26, 2009 at 03:08:21PM +0000, Andy Whitcroft wrote:
> 
> Failing that I did build a modified patch (below) based on that from the
> thread plus the suggested improvements.  This has been tested by people
> with the Logitech mice successfully, and also by people with elantech
> touchpads who report no regressions.

Good! This means the suggested fix is working :)

However, my original proposal:

   http://patchwork.kernel.org/patch/595/

also removed printing the version query result in elantech_init() to keep
the amount of log messages the same.

> If there is no later patches then perhaps you could test this one, and
> then I can push it upstream.

Dmitry suggested moving the Elantech detection down in psmouse_extensions()
in psmouse-base.c to make the mouse detection less chatty:

   http://lkml.org/lkml/2009/1/20/55

However, Alexander pointed out he did not move it far enough down:

   http://lkml.org/lkml/2009/1/22/18

It should have been moved all the way down below the call to
im_explorer_detect() for him to not see the extra Elantech detection noise.

Now, it is Dmitry's call again to determine whether he really wants to move
the call to elantech_detect() that far down or can live with the extra log
messages... :)


Arjan
