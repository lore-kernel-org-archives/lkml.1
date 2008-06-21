Return-Path: <linux-kernel-owner+w=401wt.eu-S1752337AbYFUQzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbYFUQzM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 12:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbYFUQzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 12:55:00 -0400
Received: from rtr.ca ([76.10.145.34]:2843 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbYFUQy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 12:54:59 -0400
Message-ID: <485D3260.20301@rtr.ca>
Date: Sat, 21 Jun 2008 12:54:56 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Soeren Sonnenburg <kernel@nn7.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: hdparm -M acoustic management for sata disks?
References: <1214043295.17302.16.camel@localhost>  <485D098E.3080109@rtr.ca> <1214066456.18959.6.camel@localhost>
In-Reply-To: <1214066456.18959.6.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soeren Sonnenburg wrote:
> 
> Just to be sure, did you mean grep acoustic (lowercase)? Because it is
> listed there under Capabilities: 
> Recommended acoustic management value: 128, current value: 0
..

Ahh.. That part of the output just shows the "current setting field",
which is zero (0) or "invalid" in your case.   That's a display error
in hdparm -- it probably shouldn't bother with that field when the
feature is missing from the feature list that is given lower down
in the output.  (the reason it doesn't discard it today, is that early
drives had the feature but didn't report it lower down.. but we can
distinguish those drives by ATA version number now).

Here's hdparm-8.9 on a drive that *does* support the feature:


$ hdparm -I /dev/sda | grep Acoustic
           *    Automatic Acoustic Management feature set

$ hdparm -M /dev/sda

/dev/sda:
 acoustic      = 254 (128=quiet ... 254=fast)

$ hdparm -M128 /dev/sda

/dev/sda:
 setting acoustic management to 128
 acoustic      = 128 (128=quiet ... 254=fast)

$ hdparm -M254 /dev/sda

/dev/sda:
 setting acoustic management to 254
 acoustic      = 254 (128=quiet ... 254=fast)
