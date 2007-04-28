Return-Path: <linux-kernel-owner+w=401wt.eu-S965736AbXD1Kyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965736AbXD1Kyn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 06:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965730AbXD1Kyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 06:54:43 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:51458 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965736AbXD1Kyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 06:54:41 -0400
Message-ID: <4633283C.2000301@drzeus.cx>
Date: Sat, 28 Apr 2007 12:55:56 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070414)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com>	<m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>	<Pine.LNX.4.64.0704252154250.29271@schroedinger.engr.sgi.com> <m1abwvofke.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1abwvofke.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> I have a hard time believe that device hardware limits don't allow them
> to have enough space to handle larger requests.  If so it was a poor
> design by the hardware manufacturers.
> 

In the MMC layer, the block size is a major bottle neck. None of the currently
supported hardware supports scatter/gather so we're restricted to servicing a
single continuous chunk of memory at a time. And since latency is substantial
for MMC/SD, good performance is several orders above 4k. We get ~8 MB/s for
cards which are supposed to do 20 MB/s (which has been tested against other
systems where we can get larger memory chunks), and the peasants are getting a
bit unruly.

I plan to experiment with some bounce buffer scheme to get performance up, but
getting large blocks directly would make such hacks unnecessary.

Just my two cents.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
