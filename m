Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbYAVAAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbYAVAAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 19:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759627AbYAVAAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 19:00:32 -0500
Received: from 1wt.eu ([62.212.114.60]:1473 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbYAVAAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 19:00:31 -0500
Date: Tue, 22 Jan 2008 00:32:26 +0100
From: Willy Tarreau <w@1wt.eu>
To: Jordan Crouse <jordan.crouse@amd.com>
Cc: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>,
       Andres Salomon <dilinger@queued.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc8 hangs at mfgpt-timer
Message-ID: <20080121233226.GA1052@1wt.eu>
References: <478F25D6.3060503@i4.informatik.rwth-aachen.de> <20080117134032.4cc1a1cf@ephemeral> <478FB255.5040001@i4.informatik.rwth-aachen.de> <20080117211917.GF8244@cosmic.amd.com> <478FCDB6.4010708@i4.informatik.rwth-aachen.de> <20080117223644.GK8244@cosmic.amd.com> <478FDC12.6020505@i4.informatik.rwth-aachen.de> <20080117225744.GL8244@cosmic.amd.com> <478FE733.2030806@i4.informatik.rwth-aachen.de> <20080121232709.GJ10837@cosmic.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080121232709.GJ10837@cosmic.amd.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jordan,

On Mon, Jan 21, 2008 at 04:27:09PM -0700, Jordan Crouse wrote:
> Okay - I've been exploring a little bit more.  I talked to the TinyBIOS
> developer, and he verified that TinyBIOS shouldn't use any MFGPT timers.
> He also told me that the mysterious "MFGPT workaround" was in fact the 
> magic MFGPT erasing MSR that was in the old kernel driver.
> 
> So with the "MFGPT workaround" turned off, TinyBIOS should be acting like
> the OLPC firmware with regards to timers, yet it is not.  So that is 
> curious.  I think I might have identified a race condition in the code,
> but I'm not 100% sure thats the same problem that the ALIX platform is
> seeing.
> 
> Anrd and others - will you please try the attached patch on your platform
> with the "MFGPT workaround" turned off and mfgpts enabled, and send out
> the dmesg?

Yes of course :

[   44.013100] NET: Registered protocol family 16                               
[   44.066308] geode-mfgpt:  IRQ MSR=0:0                                        
[   44.110161] geode-mfgpt:  NMI MSR=0:0                                        
[   44.154037] geode-mfgpt:  Unrestricted sources=0                             

Then it hangs here.
In another mail I sent privately to Andres, I noticed that it was the
following line which hangs at first iteration (i == 0) :

                val = geode_mfgpt_read(i, MFGPT_REG_SETUP);

I have a tinybios 0.98 with no workaround option configurable. I also
have CONFIG_GEODE_MFGPT_TIMER=n.

Hoping this helps,
Willy

