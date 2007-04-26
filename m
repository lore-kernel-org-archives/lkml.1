Return-Path: <linux-kernel-owner+w=401wt.eu-S1031220AbXDZM4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031220AbXDZM4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 08:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031211AbXDZM4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 08:56:06 -0400
Received: from smtp-104-thursday.noc.nerim.net ([62.4.17.104]:2065 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031220AbXDZM4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 08:56:04 -0400
Date: Thu, 26 Apr 2007 14:56:34 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Jordan Crouse" <jordan.crouse@amd.com>
Cc: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "David Brownell" <david-b@pacbell.net>,
       "Bryan Wu" <bryan.wu@analog.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Deepak Saxena" <dsaxena@plexity.net>, linux-kernel@vger.kernel.org,
       "Christer Weinigel" <wingel@nano-system.com>
Subject: Re: Bitbanging i2c bus driver using the GPIO API
Message-ID: <20070426145634.3ac2b7a3@hyperion.delvare>
In-Reply-To: <20070423144710.GD1372@cosmic.amd.com>
References: <11765554074106-git-send-email-hskinnemoen@atmel.com>
	<20070414163418.20490fe2@dhcp-252-105.norway.atmel.com>
	<20070414192807.60bdf84b@hyperion.delvare>
	<20070418174256.GB5577@csclub.uwaterloo.ca>
	<20070419085413.1520feef@hyperion.delvare>
	<20070419205942.GC5577@csclub.uwaterloo.ca>
	<20070420194933.0813a359@hyperion.delvare>
	<20070422154151.GJ5575@csclub.uwaterloo.ca>
	<20070423114254.71787844@hyperion.delvare>
	<20070423144710.GD1372@cosmic.amd.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007 08:47:10 -0600, Jordan Crouse wrote:
> On 23/04/07 11:42 +0200, Jean Delvare wrote:
> > I seem to remember there has been a patch floating around to
> > auto-detect the right ports back in June 2006, but it seems to have
> > been lost somehow. Jordan, do you remember?
> 
> I don't remember that, and Google isn't helping, either.  Regardless,
> randomly hitting ISA ports seems scary to me.  I know its a pain to use
> the module params all the time, but thats really probably the cleanest way
> to to it without carrying around a special patch for your system.

After digging some more, I finally managed to get my hands back on it:
http://lists.lm-sensors.org/pipermail/lm-sensors/2006-April/016009.html
http://lists.lm-sensors.org/pipermail/lm-sensors/2006-May/016053.html

This isn't "randomly hitting ISA ports", this is reading the base I/O
addresses from LPC configuration space. That's much better than letting
the user set the addresses using module parameters.

Lennart, can you please provide the output of the following commands on
your system?

isadump 0x2e 0x2f 5
isadump 0x2e 0x2f 6
isadump 0x4e 0x4f 5
isadump 0x4e 0x4f 6

(isadump is part of the lm_sensors package.)

-- 
Jean Delvare
