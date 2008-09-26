Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbYIZWEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbYIZWEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 18:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYIZWE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 18:04:28 -0400
Received: from khc.piap.pl ([195.187.100.11]:43725 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbYIZWE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 18:04:27 -0400
To: Tim Gardner <timg@tpi.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Jiri Kosina <jkosina@suse.cz>,
       "Brandeburg\, Jesse" <jesse.brandeburg@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, agospoda@redhat.com,
       "Ronciak\, John" <john.ronciak@intel.com>,
       "Allan\, Bruce W" <bruce.w.allan@intel.com>,
       "Graham\, David" <david.graham@intel.com>, kkiel@suse.de,
       tglx@linutronix.de, chris.jones@canonical.com, arjan@linux.jf.intel.com
Subject: Re: e1000e NVM corruption issue status
References: <987CEB09A2567F4A963E1E226364E2D33A685B4B@orsmsx418.amr.corp.intel.com>
	<48DCCC5F.8040609@linux.intel.com>
	<200809261052.38966.jbarnes@virtuousgeek.org>
	<200809261123.52198.jbarnes@virtuousgeek.org>
	<48DD2F98.8070509@tpi.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 27 Sep 2008 00:04:25 +0200
In-Reply-To: <48DD2F98.8070509@tpi.com> (Tim Gardner's message of "Fri\, 26 Sep 2008 12\:53\:12 -0600")
Message-ID: <m34p42mumu.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Gardner <timg@tpi.com> writes:

> I've been experimenting with unmapping flash space until its actually
> needed, e.g., in the functions that use the E1000_READ_FLASH and
> E1000_WRITE_FLASH macros. Along the way I looked at how flash write
> cycles are initiated because I was having a hard time believing that
> having flash space mapped was part of the root cause. However, it looks
> like its pretty simple to initiate a write or erase cycle. All of the
> required action bits in ICH_FLASH_HSFSTS and ICH_FLASH_HSFCTL must be 1,
> and these 2 register are in the correct order if X was writing 0xff in
> ascending order.

But... do you really have a flash chip there? I think it's more about
EEPROM (a serial usually 8-pin small chip, keeping the MAC address and
hardware configuration). Flash chips are used for diskless booting
(though corrupting them can make the machine unbootable of course).

Sure, writing to a parallel flash chip is easy, much easier than to
serial EEPROM.
-- 
Krzysztof Halasa
