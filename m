Return-Path: <linux-kernel-owner+w=401wt.eu-S1767206AbXEBSwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767206AbXEBSwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 14:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767210AbXEBSwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 14:52:53 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60615 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767206AbXEBSwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 14:52:51 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4638DDCF.7080304@s5r6.in-berlin.de>
Date: Wed, 02 May 2007 20:51:59 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
CC: Adrian Bunk <bunk@stusta.de>, Olaf Hering <olh@suse.de>,
       =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>
Subject: Re: [git pull] New firewire stack
References: <4637A29F.6070302@redhat.com> <20070502122147.GA31215@suse.de> <4638888B.4080908@s5r6.in-berlin.de> <200705020956.59804.gene.heskett@gmail.com>
In-Reply-To: <200705020956.59804.gene.heskett@gmail.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> On Wednesday 02 May 2007, Stefan Richter wrote:
>> Olaf Hering wrote:
>>> NACK.
>>> Upgrade the current drivers/ieee1394/ with the new code,
>>> and keep all existing module names.
>> I'm impartial to that.  Using same names might ease the transition from
>> the userspace side, as far as there is userland which relies on module
>> names.
>>
>> A certain drawback of same names would be that geeks cannot install both
>> stacks at once during the transition period.
[...]
> So I'd vote unconditionally to have 2 trees to select 
> from at module load time until the shakeout has produced usable code in the 
> 2nd tree.
[...]

Adrian Bunk wrote:
> An advantage of changing the names is that they are now prefixed.
> But looking at them, there will again be the point whether everyone will 
> think that "fw" is firmware, and perhaps switching to the (although 
> longer) prefix "firewire" might make sense?


Whatever names the FireWire modules will get, we shouldn't change the
names anymore _after_ the new code appears in mainline.

Anyway, if the same names really should be used, as Olaf demands, then
it affects at most ohci1394, sbp2, eth1394, ieee1394.  However, ieee1394
is probably never loaded explicitly by scripts (only auto-loaded per
dependency of the others), and the other three all have proper module
aliases.

If the new modules are meant to look like the old ones, then there is
also the problem with module parameters.  Many of the old stack's module
parameters are merely there as hacks or workarounds though;  therefore
they shouldn't appear in shipped scripts and shipped configurations anyway.
-- 
Stefan Richter
-=====-=-=== -=-= ---=-
http://arcgraph.de/sr/
