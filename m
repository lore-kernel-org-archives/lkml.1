Return-Path: <linux-kernel-owner+w=401wt.eu-S937272AbXGMUgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937272AbXGMUgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 16:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933372AbXGMUg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 16:36:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:60941 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932810AbXGMUg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 16:36:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,537,1175497200"; 
   d="scan'208";a="268023461"
Message-ID: <4697E24A.4030609@intel.com>
Date: Fri, 13 Jul 2007 13:36:26 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070623)
MIME-Version: 1.0
To: William Montgomery <william@opinicus.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: e100 PCI bridge problem
References: <4697B85B.4040902@opinicus.com>
In-Reply-To: <4697B85B.4040902@opinicus.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jul 2007 20:36:26.0942 (UTC) FILETIME=[7C46BDE0:01C7C58D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Montgomery wrote:
> In an earlier post to the list I described a hard lockup condition
> that occurs on linux kernels 2.4.22, 2.6.13, and 2.6.17 when using
> a 4 port 10/100 fast ethernet card.  The lockup is easily repeatable
> and occurs on 2 out of 3 computers.
> 
> Further testing has revealed that the lockup can be prevented on all
> computers by making sure the card is installed on the primary PCI bus.
> If the card is installed in a slot on the secondary PCI bus (behind a
> PCI to PCI bridge) the lockup occurs.

sounds like int-A/B/C/D routing issues

> Are there any PCI tuning registers that I can tweak to get around
> this problem?  Any changes I could make to the e100 driver to fix this?

this issue might be resolvable by quirking the bridgee chips and adjusting any 
APIC where needed. Unfortunately I don't know much about this but it's 
physically not possible from the e100 driver. The special (non-intel) card that 
has these 4 ports onboard contains a bridge chip itself which explains the 
issues. Even a BIOS issue could be the cause here.

Perhaps the linuxfirmwarekit will reveal more information. In any case, fixing 
this in software would be a gigantic effort.

Auke
