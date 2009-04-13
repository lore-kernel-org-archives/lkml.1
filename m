Return-Path: <linux-kernel-owner+w=401wt.eu-S1752350AbZDMUoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbZDMUoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 16:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750782AbZDMUnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 16:43:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55962
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750747AbZDMUny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 16:43:54 -0400
Date: Mon, 13 Apr 2009 13:43:45 -0700 (PDT)
Message-Id: <20090413.134345.160028379.davem@davemloft.net>
To: holt@sgi.com
Cc: mcarlson@broadcom.com, mchan@broadcom.com, benli@broadcom.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: Linux 2.6.30-rc1 tg3 endian issues with MAC addresses on
 BCM5701. Bisected.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090413201558.GK10768@sgi.com>
References: <20090408071204.GG10768@sgi.com>
	<20090413175724.GA11076@xw6200.broadcom.net>
	<20090413201558.GK10768@sgi.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Holt <holt@sgi.com>
Date: Mon, 13 Apr 2009 15:15:58 -0500

> On Mon, Apr 13, 2009 at 10:57:24AM -0700, Matt Carlson wrote:
>> Thank you for doing this bisection Robin.  This, and the data you
>> provided in your previous email is really helpful.  Unfortunately, they
>> raise more questions than answers.
>> 
>> I reviewed this patch again, and it still looks correct to me.  It
>> should be one big behavioral no-op.  Obviously something is wrong, but
>> I'm not seeing the root cause at the moment.  I need to think about this
>> some more.
> 
> If you want me to build test kernels with debug printk's, etc.  Let me
> know.  I will be working that issue on the side, so my responses may be
> slightly delayed.  I have access to many tests machines that exhibit
> this problem.
> 
> The problem seems to affect BCM5701 based systems only.  BCM5704 have
> the correct MAC addresses.  Nearly all of our SGI Altix 3700/4700
> machines have the BCM5701 adapters on their base I/O board.

I think it's only going to hit chips that access those particular
NVRAM chip read/write paths.

Matt, realize that on big-endian there are implicit endian
conversions going on.  The read*/write* macros are converting
little-to-big endian on big-endian systems.

Actually, is that the case, that we only see this corrupt MAC
address bug on big-endian systems?  Or are we seeing this on
little-endian too?
