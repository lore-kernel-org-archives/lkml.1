Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbXITMqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbXITMqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 08:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbXITMqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 08:46:11 -0400
Received: from herkules.vianova.fi ([194.100.28.129]:40295 "HELO
	mail.vianova.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752245AbXITMqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 08:46:10 -0400
Date: Thu, 20 Sep 2007 15:45:37 +0300
From: Ville Herva <v@iki.fi>
To: Willy Tarreau <w@1wt.eu>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: 2.4.35 SMP: ext3_readdir: bad entry in directory #323888: rec_len is smaller than minimal
Message-ID: <20070920124537.GB5076@vianova.fi>
Reply-To: v@iki.fi
References: <20070918122314.GL29062@vianova.fi> <20070918151206.GC13304@atrey.karlin.mff.cuni.cz> <20070918160949.GR29062@vianova.fi> <20070918162256.GA3280@atrey.karlin.mff.cuni.cz> <20070918163326.GT29062@vianova.fi> <20070918214705.GG10199@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918214705.GG10199@1wt.eu>
X-Operating-System: Linux herkules.vianova.fi 2.4.35
User-Agent: Mutt/1.5.10i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 11:47:05PM +0200, you [Willy Tarreau] wrote:
> Thanks for your report. Unfortunately, I've rechecked the recent changelogs
> and see nothing related either. At least, in order to keep trace of the
> incident, would you please post some info about your config (CPU, RAM,
> chipset, .config, gcc, and any possible patches you may have applied) ?
> Maybe some of these info may remind old bad memories to some people.
> 
> Also, do you know if this server has ECC memory ? I would more easily
> bet for side effects of one random bit flip in memory than for some
> massive block corruption.
> 
> I vaguely remember about very old reports of people sometimes observing
> zeroed out blocks during writes, which were attributed to chipset bugs
> if my memory serves me. But I would rule this out as recent chipsets
> look more stable than 5-10 years ago !

Willy,

The machine is a virtual machine on an VMware ESX 3.0.1 host.

/proc/cpuinfo shows two of these:
Dual
model           : 15
model name      : Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz
stepping        : 8
cpu MHz         : 2333.014
cache size      : 64 KB

It has 864MB of memory.

.config is at:
http://v.iki.fi/~vherva/tmp/2.4.35-config
The kernel is plain vanilla 2.4.35 from kernel.org, no patches.

gcc 2.96-129:
cat /proc/version 
Linux version 2.4.35 (root) (gcc version 2.96 20000731 (Red Hat Linux 7.2 2.96-129.7.2)) #1 SMP Thu Aug 9 10:35:37 EEST 2007

Memory is ECC.

The server is HP Proliant ML370 with 82801BA/CA/DB/EB chipset. I've had my
share of chipset bugs with older Via chipsets, but I think it's very likely
in this case.

This could very well be a VMware bug, but I wanted to know if this rings
bells for someone.


-- v -- 

v@iki.fi

