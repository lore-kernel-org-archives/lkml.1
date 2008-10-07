Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbYJGUlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbYJGUlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 16:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbYJGUl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 16:41:27 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3227 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbYJGUl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 16:41:26 -0400
Date: Tue, 7 Oct 2008 21:39:46 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@rpsys.net>
Message-ID: <20081007203946.GA3514@sirena.org.uk>
References: <1223374230-18413-1-git-send-email-giometti@enneenne.com> <20081007135420.GB1592@ucw.cz> <20081007152032.GH13035@tekkaman> <20081007185846.GA6604@elf.ucw.cz> <20081007192112.GL13035@tekkaman> <20081007195648.GD6604@elf.ucw.cz> <20081007201954.GM13035@tekkaman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007201954.GM13035@tekkaman>
X-Cookie: It's clever, but is it art?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.32.140.119
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V3] led: Backlight trigger for led subsystem
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 10:19:54PM +0200, Rodolfo Giometti wrote:
> On Tue, Oct 07, 2008 at 09:56:48PM +0200, Pavel Machek wrote:

> > Hmm, what's "your board"?

> Sorry, I meant "my custom board". :) It's PXA270 based but it's not
> into Linux main tree.

Another example, support for which should be coming shortly, is the LED
driver provided by the WM8350: this is a PMIC capable of producing outputs
to drive LEDs, potentially strings of very bright LEDs.  This is frequently
used to illuminate displays but the actual function depends entirely on how
the system has been wired up.

The implementation is identical no matter what the LEDs are doing but the
current out of tree drivers have two drivers for this bit of the hardware,
one for use in the normal LED case and one for when used as a backlight,
which is redundnant.  With the driver Rodolfo has written this should no
longer be required and the backlight trigger can be used to share the
hardware interface code.
