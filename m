Return-Path: <linux-kernel-owner+w=401wt.eu-S932931AbYBGSWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931AbYBGSWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 13:22:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759677AbYBGSWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 13:22:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:44885 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755907AbYBGSWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 13:22:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,316,1199692800"; 
   d="scan'208";a="514924157"
Message-ID: <47AB4B2E.1030801@intel.com>
Date: Thu, 07 Feb 2008 10:17:18 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: kernel list <linux-kernel@vger.kernel.org>,
       e1000-devel@lists.sourceforge.net, john.ronciak@intel.com,
       jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [E1000-devel] e1000 1sec latency problem
References: <20080207141718.GA2030@elf.ucw.cz>
In-Reply-To: <20080207141718.GA2030@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
> I have the famous e1000 latency problems:
> 
> 64 bytes from 195.113.31.123: icmp_seq=68 ttl=56 time=351.9 ms
> 64 bytes from 195.113.31.123: icmp_seq=69 ttl=56 time=209.2 ms
> 64 bytes from 195.113.31.123: icmp_seq=70 ttl=56 time=1004.1 ms
> 64 bytes from 195.113.31.123: icmp_seq=71 ttl=56 time=308.9 ms
> 64 bytes from 195.113.31.123: icmp_seq=72 ttl=56 time=305.4 ms
> 64 bytes from 195.113.31.123: icmp_seq=73 ttl=56 time=9.8 ms
> 64 bytes from 195.113.31.123: icmp_seq=74 ttl=56 time=3.7 ms
> 
> ...and they are still there in 2.6.25-git0. I had ethernet EEPROM
> checksum problems, which I fixed by the update, but problems are not
> gone.

pavel, start using "e1000e" instead - this driver replaces e1000 for all the
pci-express devices and has the infamous L1 ASPM disable patch to fix this issue.

make sure you have CONFIG_E1000E=m/y in your .config, otherwise the old e1000 code
will drive your card, and that driver does not have the fix.

BAH, this is a good example how Linus' patch can wreak havoc - a lot of people
will now not see fixes since they only go into e1000e, but people can unnoticed
now go and use e1000 for too long...

Auke
