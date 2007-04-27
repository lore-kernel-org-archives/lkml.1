Return-Path: <linux-kernel-owner+w=401wt.eu-S1754336AbXD0Sxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbXD0Sxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 14:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754344AbXD0Sxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:53:33 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:42974 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754310AbXD0Sxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:53:32 -0400
Date: Fri, 27 Apr 2007 14:53:31 -0400
To: Jordan Crouse <jordan.crouse@amd.com>
Cc: Jean Delvare <khali@linux-fr.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Brownell <david-b@pacbell.net>, Bryan Wu <bryan.wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Deepak Saxena <dsaxena@plexity.net>, linux-kernel@vger.kernel.org,
       Christer Weinigel <wingel@nano-system.com>
Subject: Re: Bitbanging i2c bus driver using the GPIO API
Message-ID: <20070427185331.GG5577@csclub.uwaterloo.ca>
References: <20070420194933.0813a359@hyperion.delvare> <20070422154151.GJ5575@csclub.uwaterloo.ca> <20070423114254.71787844@hyperion.delvare> <20070423144710.GD1372@cosmic.amd.com> <20070426145634.3ac2b7a3@hyperion.delvare> <20070426132905.GP5575@csclub.uwaterloo.ca> <20070426133920.GA25456@cosmic.amd.com> <20070426140323.GE5577@csclub.uwaterloo.ca> <20070427100204.403d068c@hyperion.delvare> <20070427144949.GD28203@cosmic.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427144949.GD28203@cosmic.amd.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 08:49:49AM -0600, Jordan Crouse wrote:
> This is getting confusing... :)  On the sc1200 and and GX1, the ACB
> bus is accessed through ISA ports.  There is no ISA on the cs5535/cs5536
> companion chips (accompanying the GX and LX processors), and the ACB
> is accessed through PCI.  All the platforms have LPC, but that really
> doesn't matter for the purposes of this discussion.
> 
> The silicon block that implements the ACB has been generally unchanged
> over the last 6 or 7 years, so the same driver should support any of
> the platforms, assuming one can invoke the magic spells to get at the
> hardware.  Jean and I have been concentrating most of our effort on 
> getting the GX and LX to work through PCI, and really haven't concentrated
> our efforts on the older processors.  Thats not to say it won't work,
> but its probably not plug and play.

Well the SC1200 has an ACB but it is disabled by default through one of
the gpio multiplex selector bits.  According to the data sheet only the
bios knows where that is.  So instead the gpio's (12 and 13) that are
multiplexed with acb #2 are driven by scx200_i2c using the bit banged
interface.  Makes it work for those of us that don't have access to
changing the bios.

Unfortuantely I don't think the scx200 gpio's have been rewritten to use
the new gpio interface.  If it was I would try to see if the new i2c
driver would work if told to use gpio 12 and 13.

scx200_i2c does depend on i2c-algo-bit so there is really very little
code inside scx200_i2c itself.  Does the new driver replace
i2c-algo-bit as well or does it use it?

--
Len Sorensen
