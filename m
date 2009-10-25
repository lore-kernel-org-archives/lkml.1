Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638AbZJYD2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbZJYD2P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 23:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbZJYD2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 23:28:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbZJYD2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 23:28:14 -0400
Date: Sat, 24 Oct 2009 23:28:14 -0400
From: Dave Jones <davej@redhat.com>
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: cpufreq@vger.kernel.org, LKLM <linux-kernel@vger.kernel.org>,
       Rafal Bilski <rafalbilski@interia.pl>
Subject: Re: [PATCH] longhaul: select Longhaul version 2 for capable CPUs
Message-ID: <20091025032813.GB2475@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Krzysztof Helt <krzysztof.h1@poczta.fm>, cpufreq@vger.kernel.org,
	LKLM <linux-kernel@vger.kernel.org>,
	Rafal Bilski <rafalbilski@interia.pl>
References: <20091024172538.e2c8776b.krzysztof.h1@poczta.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091024172538.e2c8776b.krzysztof.h1@poczta.fm>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 24, 2009 at 05:25:38PM +0200, Krzysztof Helt wrote:
 > From: Krzysztof Helt <krzysztof.h1@wp.pl>
 > 
 > There is a typo in the longhaul detection code so only Longhaul v1 or Longhaul v3
 > is selected. The Longhaul v2 is not selected even for CPUs which are capable of.
 > 
 > Tested on PCChips Giga Pro board. Frequency changes work and the Longhaul v2
 > detects that the board is not capable of changing CPU voltage.
 > 
 > Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
 
It seems we deliberately changed this two years ago, though the changelog
is a bit sparse on details..

commit 07844252ffd81ec192a62014bada1016c9703765
Author: Rafal Bilski <rafalbilski@interia.pl>
Date:   Sun Apr 22 12:26:04 2007 +0200

    [CPUFREQ] Longhaul - Revert Longhaul ver. 2
    
    There is something wrong with this code. It needs more
    testing. It is better to disable it for now because support
    for some machines will be broken.
    
    Signed-off-by: Rafal Bilski <rafalbilski@interia.pl>
    Signed-off-by: Dave Jones <davej@redhat.com>


In hindsight, changing it to report V1 instead of V2 was the wrong thing
to do, and we should have done something like -ENODEV with
a printk explaining why.

I've not got any old VIA CPUs/boards to test with any more, but I'm inclined
to apply your change, but we'll have to keep an eye out for any strange
bugs on affected systems.  Currently this driver should do nothing, as the
longhaul v1 registers that don't exist on longhaul V2 CPUs. With this change,
we're going to be actually doing scaling again, which may introduce instability
on some machines, as iirc, we never did get this driver 100% stable due
to a lot of really crappy motherboards.

Perhaps we should printk a warning related to this.
(We should definitly mention it in the Kconfig too, which I thought we already had)

	Dave

