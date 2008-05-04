Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbYEDOfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbYEDOfi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 10:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbYEDOf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 10:35:29 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:47985 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbYEDOf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 10:35:28 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <481DC997.3070901@s5r6.in-berlin.de>
Date: Sun, 04 May 2008 16:35:03 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: config NONPROMISC_DEVMEM: help text and logic are confusing
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject option, prompt "Disable promiscuous /dev/mem" in the menu 
called "Kernel hacking", does the following as far as I understand the 
patch description in commit ae531c26c5c2a28ca1b35a75b39b3b256850f2c8:

y = tighter security of /dev/mem,
n = unfiltered access through /dev/mem.

Yet the Kconfig help text contains the sentence

	With this config option, you allow userspace access to all of
	memory, [...]

Shouldn't this read

	Say N to allow userspace access to all of memory, [...]

	Say Y if you want improved security.

Also see commit 1f56cf1c58c81f7ecf16f5e99ac4a333d9dc9aea:  This changed 
the default of the option from y to n.  But the help text still says:

	The /dev/mem file by default only allows userspace access to PCI
	space and the BIOS code and data regions.

This is apparently wrong with "default n".

Furthermore, most of the options in the "Kernel hacking" menu follow the 
logic of "Y = additional debug features", "N = for normal use".  With 
NONPROMISC_DEVMEM it is the other way around.  Besides, an option whose 
prompt says "Disable something" is generally bad; better is "Enable 
something" because this is what the vast majority of options do and thus 
avoid "yes means no" logic.

So, wouldn't it be better to have

config PROMISCUOUS_DEVMEM
	bool "Promiscuous /dev/mem"
	# default to old semantics for a transition period
	default y
	help
	  This option opens up /dev/mem for access to all memory which
	  is useful for debugging and for [insert other uses here:
	  buggy legacy applications?] ...

	  Say Y if...
	  If ..., say N.

If I misunderstood something, please correct me.  And the Kconfig entry 
and its help text too, because I believe I won't be the only earthling 
who gets it wrong.  Thanks,
-- 
Stefan Richter
-=====-==--- -=-= --=--
http://arcgraph.de/sr/
