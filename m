Return-Path: <linux-kernel-owner+w=401wt.eu-S1761892AbXEWGeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761892AbXEWGeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 02:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756767AbXEWGd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 02:33:57 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40252 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756670AbXEWGd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 02:33:57 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4653DFF1.5070807@s5r6.in-berlin.de>
Date: Wed, 23 May 2007 08:32:17 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Dan Dennedy <dan@dennedy.org>, Pieter Palmers <pieterp@joow.be>
CC: Arnd Bergmann <arnd@arndb.de>, Petr Vandrovec <petr@vandrovec.name>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix/add raw1394 CONFIG_COMPAT code
References: <20070507021447.GA22197@vana.vc.cvut.cz> <200705201703.37561.arnd@arndb.de> <46506912.9020904@s5r6.in-berlin.de> <200705222154.24787.dan@dennedy.org>
In-Reply-To: <200705222154.24787.dan@dennedy.org>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Dennedy wrote:
> On Sunday 20 May 2007 08:28, Stefan Richter wrote:
>> maybe we should change
...
>> struct raw1394_cycle_timer {
[to consist of two u64 to get same alignment on all architectures]
...
>> before a libraw1394 with get-cycle-timer support is released.
>> Shall I prepare according patches for raw1394 and libraw1394?
> 
> This seems like a good idea, and I have forwarded it to the ffado (formerly 
> freebob) developers, specifically Pieter Palmers--the submitter of 
> raw1394_read_cycle_timer--to get his feedback.

I'll post the patches tonight to see how it will look like.  Even though
I already posted the kernel-only patch which adjusts
raw1394_iso_packets32 per architecture, the 2x u64 variant may overall
be nicer:  a) it eliminates the need for raw1394_cycle_timer32,  b) the
get-cycle-timer ABI still has to be duplicated in Juju, and Juju so far
did not require different struct types for 32bit compatibility ioctls.
-- 
Stefan Richter
-=====-=-=== -=-= =-===
http://arcgraph.de/sr/
