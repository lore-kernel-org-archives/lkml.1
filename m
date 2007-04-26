Return-Path: <linux-kernel-owner+w=401wt.eu-S1031025AbXDZN3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031025AbXDZN3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 09:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbXDZN3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 09:29:10 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:47493 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753976AbXDZN3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 09:29:09 -0400
Date: Thu, 26 Apr 2007 09:29:06 -0400
To: Jean Delvare <khali@linux-fr.org>
Cc: Jordan Crouse <jordan.crouse@amd.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Brownell <david-b@pacbell.net>, Bryan Wu <bryan.wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Deepak Saxena <dsaxena@plexity.net>, linux-kernel@vger.kernel.org,
       Christer Weinigel <wingel@nano-system.com>
Subject: Re: Bitbanging i2c bus driver using the GPIO API
Message-ID: <20070426132905.GP5575@csclub.uwaterloo.ca>
References: <20070414163418.20490fe2@dhcp-252-105.norway.atmel.com> <20070414192807.60bdf84b@hyperion.delvare> <20070418174256.GB5577@csclub.uwaterloo.ca> <20070419085413.1520feef@hyperion.delvare> <20070419205942.GC5577@csclub.uwaterloo.ca> <20070420194933.0813a359@hyperion.delvare> <20070422154151.GJ5575@csclub.uwaterloo.ca> <20070423114254.71787844@hyperion.delvare> <20070423144710.GD1372@cosmic.amd.com> <20070426145634.3ac2b7a3@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426145634.3ac2b7a3@hyperion.delvare>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 02:56:34PM +0200, Jean Delvare wrote:
> After digging some more, I finally managed to get my hands back on it:
> http://lists.lm-sensors.org/pipermail/lm-sensors/2006-April/016009.html
> http://lists.lm-sensors.org/pipermail/lm-sensors/2006-May/016053.html
> 
> This isn't "randomly hitting ISA ports", this is reading the base I/O
> addresses from LPC configuration space. That's much better than letting
> the user set the addresses using module parameters.
> 
> Lennart, can you please provide the output of the following commands on
> your system?
> 
> isadump 0x2e 0x2f 5
> isadump 0x2e 0x2f 6

These return all 0xff.  For example:

router2:~# isadump 0x2e 0x2f 5
WARNING! Running this program can cause system crashes, data loss and worse!
I will probe address register 0x2e and data register 0x2f.
Probing bank 5 using bank register 0x07.
Continue? [Y/n]
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff

> isadump 0x4e 0x4f 5
> isadump 0x4e 0x4f 6

These return all 0x00

On the Geode LX800 where scx200_acb does work all 4 commands return all
0xff.

--
Len Sorensen
