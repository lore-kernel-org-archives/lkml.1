Return-Path: <linux-kernel-owner+w=401wt.eu-S1758440AbZAURwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758440AbZAURwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 12:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbZAURwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 12:52:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36753 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbZAURwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 12:52:16 -0500
Date: Wed, 21 Jan 2009 18:51:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Allan, Bruce W" <bruce.w.allan@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: e1000e regression (interface hang) with latest -git
Message-ID: <20090121175158.GA7302@elte.hu>
References: <20090121102840.GA24967@elte.hu> <8DD2590731AB5D4C9DBF71A877482A900DABEA6F@orsmsx509.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8DD2590731AB5D4C9DBF71A877482A900DABEA6F@orsmsx509.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Allan, Bruce W <bruce.w.allan@intel.com> wrote:

> >-----Original Message-----
> >From: Ingo Molnar [mailto:mingo@elte.hu]
> >Sent: Wednesday, January 21, 2009 2:29 AM
> >To: linux-kernel@vger.kernel.org; Kirsher, Jeffrey T; Brandeburg, Jesse;
> >Allan, Bruce W; Waskiewicz Jr, Peter P; e1000-devel@lists.sourceforge.net;
> >netdev@vger.kernel.org
> >Cc: Rafael J. Wysocki
> >Subject: e1000e regression (interface hang) with latest -git
> >
> >
> >I've got a Nehalem testbox that developed a new e1000e problem in this
> >merge window: after a few minutes of uptime the network interface goes
> >dead - no rx and no tx. If i ifdown/ifup the interface it comes back. If i
> >wait too long then even ifdown/ifup does not help anymore - only a reboot.
> >
> >Other e1000e using testboxes i have are working just fine - so the problem
> >is specific to this hw.
> >
> >Is this a known problem?
> >
> >I have this hw:
> >
> > 01:00.0 Ethernet controller: Intel Corporation 82575EB Gigabit Network
> >Connection (rev 02)
> > 01:00.1 Ethernet controller: Intel Corporation 82575EB Gigabit Network
> >Connection (rev 02)
> >
> >If this is a new problem, what kind of other info do you need from me to
> >debug and fix this?
> >
> >I started seeing this very early in the merge window, so candidates would
> >be one of these early commits:
> >
> >eb14f01: Merge branch 'master' of
> >master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6
> >cb7b48f: igb/e1000e: Naming interrupt vectors
> >5b9ab2e: Merge branch 'master' of
> >master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6
> >e243455: e1000e: check return code from NVM accesses and fix bank
> >detection
> >a20e4cf: e1000e: fix incorrect link status when switch module pulled
> >8452759: e1000e: store EEPROM version number to prevent unnecessary NVM
> >reads
> >0285c8d: e1000e: cosmetic newline in debug message
> >5c48ef3: e1000e: sync change flow control variables with ixgbe
> >8f12fe8: e1000e: link up/down messages must follow a specific format
> >75eb0fa: e1000e: ESB2 config after link up
> >438b365: e1000e: check return of pci_save_state
> >1605927: e1000e: update comments listing supported parts for each MAC
> >family
> >63dcf3d: e1000e: 82571 check for link fix on 82571 serdes
> >5aa49c8: e1000e: commit speed/duplex changes for m88 PHY
> >005cbdf: e1000e: disable correctable errors for quad ports while going to
> >D3
> >0082982: netdev: add more functions to netdevice ops
> >651c246: e1000e: convert to net_device_ops
> >198d6ba: Merge branch 'master' of
> >master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6
> >6ea7ae1: e1000e: enable ECC correction on 82571 silicon
> >4cf1653: netdevice: safe convert to netdev_priv() #part-2
> >babcda7: drivers/net: Kill now superfluous ->last_rx stores.
> >7c510e4: net: convert more to %pM
> >
> >If you suspect a specific list of commits i can test their revert. (But
> >the box is a slow booter and the problem can take up to 15 minutes to
> >trigger so i'd rather not spend half a day bisecting it, if it can be
> >avoided.)
> >
> >Thanks,
> >
> >	Ingo
> 
> 82575EB is not supported by e1000e, it is supported by igb.  Are you 
> sure that is the correct device?  Please send the system log and output 
> of:

yeah - sorry, i got confused - it is using IGB:

 CONFIG_IGB=y
 CONFIG_IGB_LRO=y

The same point remains though: it worked before (and works fine with a 
distro kernel, 2.6.28-0.140.rc9.git1.fc11.x86_64) and doesnt work with 
latest -git.

I'll capture some debug data and send it to you.

	Ingo

