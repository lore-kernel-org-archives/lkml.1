Return-Path: <linux-kernel-owner+w=401wt.eu-S932629AbYEFTqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629AbYEFTqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 15:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756760AbYEFTpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 15:45:44 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54133 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354AbYEFTpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 15:45:31 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4820B524.5080100@s5r6.in-berlin.de>
Date: Tue, 06 May 2008 21:44:36 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Alistair John Strachan <alistair@devzero.co.uk>, Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.26-rc1
References: <alpine.LFD.1.10.0805031205330.2971@woody.linux-foundation.org>	<20080504160904.GF19717@sgi.com>	<Pine.LNX.4.64.0805051656180.3218@bombadil.infradead.org>	<200805060902.25835.alistair@devzero.co.uk>	<20080506073134.424780a3@gaivota>	<48206C73.80509@s5r6.in-berlin.de> <20080506161346.183f367c@gaivota>
In-Reply-To: <20080506161346.183f367c@gaivota>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab wrote:
> On Tue, 06 May 2008 16:34:27 +0200
> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> But it is /trivial/ to fix.  If A selects B, you have to copy all of B's
>> dependencies to A or select these dependencies by A.
>>
>> So it's totally simple to do it right.  The only nuisance is that you
>> always have to update B's dependencies and selections whenever A's
>> dependencies are changed.
> 
> This is easy to maintain, if you have just a few selects, but this is not the
> case of V4L drivers. Look some examples:
> 
> IVTV driver:
[...]
> You may argue to not use select, but it is really hard to avoid, since each of
> those main drivers (cx88, ivtv, bttv, etc) supports a large number of different
> devices, that needs different chips. Most V4L/DVB devices has an internal I2C
> bus that gives the flexibility for the board manufacturers to add/replace the
> internal components at the i2c bus. So, the Kernel uses abstraction layers that
> allows that the same driver to use different internal components.

Shouldn't layers actually untangle dependencies, i.e. concentrate 
dependencies?  A "high-level driver" does not depend on "low-level 
drivers" and the low-level drivers' dependencies anymore.  It only 
depends on a "core driver" and on foreign subsystem APIs.

And yes, the core driver may very well provide some functionality which 
not all of the high-level drivers need, or not all of the low-level 
drivers are able to support.

(All theoretical since I have no idea of what kinds of modules of 
functionality you have/need and whether it really can be simpler organized.)
-- 
Stefan Richter
-=====-==--- -=-= --==-
http://arcgraph.de/sr/
