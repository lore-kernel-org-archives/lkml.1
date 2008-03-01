Return-Path: <linux-kernel-owner+w=401wt.eu-S932981AbYCACaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981AbYCACaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 21:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbYCACaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 21:30:05 -0500
Received: from smtp01.uc3m.es ([163.117.176.131]:51887 "EHLO smtp01.uc3m.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbYCACaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 21:30:04 -0500
X-Greylist: delayed 466 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Feb 2008 21:30:04 EST
From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Message-Id: <200803010222.m212MAq16160@inv.it.uc3m.es>
Subject: Re: sysctl in 2.6.24.2 excludes unapproved files from /proc/sys?
In-Reply-To: <b6fcc0a0802291746y7375ba71ja0dc0beb58c4ccb1@mail.gmail.com> 
	from"Alexey Dobriyan" at "Mar 1, 2008 04:46:41 am"
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Date: Sat, 1 Mar 2008 03:22:10 +0100 (MET)
CC: ptb@inv.it.uc3m.es, "linux kernel" <linux-kernel@vger.kernel.org>
X-Anonymously-To: 
Reply-To: ptb@inv.it.uc3m.es
X-message-flag: Had your Outlook virus, today?  
	http://www.counterpane.com/crypto-gram-0103.html#4
X-WebTV-Stationery: Standard\; BGColor=black\; TextColor=black
Reply-By: Sat, 1 Apr 2006 14:21:08 -0700
X-Mailer: ELM [version 2.4ME+ PL66 (25)]
X-imss-version: 2.050
X-imss-result: Passed
X-imss-scanInfo: M:B L:N SM:2
X-imss-tmaseResult: TT:1 TS:-14.5450 TC:1F TRN:66 TV:5.0.1023(15760.002)
X-imss-scores: Clean:100.00000 C:0 M:0 S:0 R:0
X-imss-settings: Baseline:1 C:1 M:1 S:1 R:1 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Also sprach Alexey Dobriyan:"
> On 3/1/08, Peter T. Breuer <ptb@inv.it.uc3m.es> wrote:
> > A change in 2.6.24.x kernel/sysctl.c seems to exclude exo-kernel drivers
> > from using the /proc/sys/ interface:
> 
> That's somewhat correct.

OK.  Thanks.  That's a relief.  It's always good to know that it's the
universe that's crazy, not me.

> > What's a person to do?
> 
> If I understand you correcty, the answer is drop '.ctl_name' bits from
> new sysctls and make sure common parts of tables match the ones
> in mainline.

You are saying, O wise delphic oracle, that I *can* add stuff in the
/proc/sys tree, provided it's at an approved leaf?  Or that I must use
CTL_UNNUMBERED for flipping efferything, not just most things?  (one
would have thought one was entitled to number things in ones own
subdirectories, failing some comment to the contrary).  I tried
CTL_UNNUMBERED at least on my top level directory, and didn't add any
entries to it, and THAT failed. So on the face of it that
interpretation of your words cannot be correct.

/proc/sys/dev is where I am trying to add a directory, because I am none
of

        { DEV_CDROM,    "cdrom",        trans_cdrom_table },
        { DEV_PARPORT,  "parport",      trans_parport_table },
        { DEV_RAID,     "raid",         trans_raid_table },
        { DEV_MAC_HID,  "mac_hid",      trans_mac_hid_files },
        { DEV_SCSI,     "scsi",         trans_scsi_table },
        { DEV_IPMI,     "ipmi",         trans_ipmi_table },

and those are the legal entries at the moment, and I can't see any
commonality in or among any of those or between them and me. 

That's not a leaf.  However, none of its eventual leaves have anything
to do with my driver.  So here in dev/ would be just fine to plonk a new
device driver subtree, methinks.

And you want me to use CTL_UNNUMBERED for everything in my subtree
from where it branches off?

OK. I'm game. I'll try. I've tried a lot of other things over the past
few days.

And how am I supposed to maintain this driver, now that it's full of
#iffoo < 2.6.24 every two lines?

And while I am here, what's the purpose of this change? What's the
point of checking that only the pre-approved entries to this tree are
made? I don't get it! If you don't want somebody adding something
to /proc/sys just delete their registration call from the kernel
tree, surely! Is this some sort of in-kernel fight? Defenders of
/proc/sys against attackers? Is the problem that one can't persuade
some maintainers to stop their authors from adding to /proc/sys, so
instead it's been made it necessary to ask permission of the /proc/sys
maintainer instead via this change?

Now every author has to make a change in their code AND make a change in
the sysctl code in a totally different part of the kernel when they want
a single change - adding a file or dir to their file hierarchy.

And what's the registration function for, now that the details are
largely there in sysctl.c and sysctl_check.c? It just adds detail
like strategy and proc_handler? And says when to put up and tear down
the subtree in question? Why not move ALL the detail over to
kernel/sysctl.c too!

(if you think I think it's crazy, yes, you are not so crazy).

Peter








 



