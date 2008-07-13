Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbYGMXcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbYGMXcV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 19:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbYGMXcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 19:32:11 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:48006 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbYGMXcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 19:32:09 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: benh@kernel.crashing.org
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Matthew Wilcox <matthew@wil.cx>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "jgarzik@pobox.com" <jgarzik@pobox.com>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
       "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>
References: <20080711005719.GO14894@parisc-linux.org>
	<m1iqvc91li.fsf@frodo.ebiederm.org>
	<20080711215943.GW1678@linux-os.sc.intel.com>
	<m1d4lkauxc.fsf@frodo.ebiederm.org>
	<1215834720.7549.154.camel@pasglop>
	<m13amf3eak.fsf@frodo.ebiederm.org>
	<1215848161.7549.166.camel@pasglop>
	<m1iqv9a030.fsf@frodo.ebiederm.org>
	<1215989044.7549.219.camel@pasglop>
Date: Sun, 13 Jul 2008 16:29:45 -0700
In-Reply-To: <1215989044.7549.219.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Mon, 14 Jul 2008 08:44:04 +1000")
Message-ID: <m1tzet2wie.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;benh@kernel.crashing.org
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4391]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: Multiple MSI, take 3
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ben.  Multi-MSI is a crap hardware design.  Why do you think we have
MSI-X?  MSI-X as specced is a properly operating irq controller that
we don't need kludges to support.  Multi-MSI with a full set of
kludges almost work but not quite fits the linux irq model.

Any hardware designer who choose to implement Multi-MSI instead of
MSI-X was not really concerned about having a high performance device.

If we can find a way to model the portable capabilities of Multi-MSI
cleanly then we can support it, and our drivers and our users and our
intermediate layers won't get surprised.

So far we have too close fits but neither model really works.

Further this is all about driver optimization, so none of this is
necessary to have working hardware.  Which makes kludges much less
appropriate.  Modelling Multi-MSI irqs as normal irqs requires a lot
of nasty kludges.

One of the kludges is allocating a continuous chunk of irq targets,
and the resulting fragmentation issues that you get when you start
allowing different sized allocations.

Overall if Multi-MSI was to become common I think we would really
regret it.

Eric
