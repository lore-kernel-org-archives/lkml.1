Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbXKXWUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbXKXWUq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 17:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbXKXWUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 17:20:39 -0500
Received: from smtp-106-saturday.nerim.net ([62.4.16.106]:53848 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752550AbXKXWUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 17:20:38 -0500
Date: Sat, 24 Nov 2007 23:20:35 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: benh@kernel.crashing.org, Roger Leigh <rleigh@whinlatter.ukfsn.org>,
       linux-kernel@vger.kernel.org, Dennis Munsie <dmunsie@cecropia.com>
Subject: Re: radeonfb i2c regression post-2.6.18.
Message-ID: <20071124232035.0f46d530@hyperion.delvare>
In-Reply-To: <200711241518.26755.mb@bu3sch.de>
References: <1195427766.7022.18.camel@pasglop>
	<200711231700.53103.mb@bu3sch.de>
	<20071123232928.467378a7@hyperion.delvare>
	<200711241518.26755.mb@bu3sch.de>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Nov 2007 15:18:26 +0100, Michael Buesch wrote:
> On Friday 23 November 2007 23:29:28 Jean Delvare wrote:
> > Out of curiosity, what kind of crash was it? I admit that I can't see
> > how the code could crash.
> 
> It's not the code that crashes. It's the hardware that turns off the machine.
> It only happens if I boot the machine and only if it's hot at this
> time. Some hardware will turn off the hardware two or three seconds
> after the radeon driver was loaded.
> It seems to be some overheating protection that's going crazy.

Very strange indeed. Another possibility is that there is a hardware
monitoring chip connected to one of the Radeon adapter's I2C buses, and
that holding the I2C lines prevents reading from it, so whatever is
responsible for controlling the temperature prefers to play it safe and
shuts everything down. Somehow it seems more realistic than an actual
overheating (3 seconds is a very short period of time for that), but
we'd need the exact schematics of the hardware, and the details of the
thermal control system, to validate this theory.

Anyway, no need to worry anymore now that the bug is fixed :)

-- 
Jean Delvare
