Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbYGKLmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbYGKLmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbYGKLmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:42:10 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33131 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbYGKLmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:42:08 -0400
X-Greylist: delayed 1805 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jul 2008 07:42:08 EDT
From: ebiederm@xmission.com (Eric W. Biederman)
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       grundler@parisc-linux.org, mingo@elte.hu, tglx@linutronix.de,
       jgarzik@pobox.com, linux-ide@vger.kernel.org, suresh.b.siddha@intel.com,
       benh@kernel.crashing.org, jbarnes@virtuousgeek.org,
       rdunlap@xenotime.net, mtk.manpages@gmail.com
References: <20080711005719.GO14894@parisc-linux.org>
	<m1iqvc91li.fsf@frodo.ebiederm.org>
	<20080711102326.GR14894@parisc-linux.org>
Date: Fri, 11 Jul 2008 04:34:19 -0700
In-Reply-To: <20080711102326.GR14894@parisc-linux.org> (Matthew Wilcox's
	message of "Fri, 11 Jul 2008 04:23:26 -0600")
Message-ID: <m1iqvc7iys.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Matthew Wilcox <matthew@wil.cx>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.0999]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: Multiple MSI, take 3
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is one idea that seems to model this cleanly
without breaking all kinds of expectations.

That is an irq with a very small data payload.

In that case we wire all of the vectors up to a single
irq handler that computes the payload as:
payload = vector - base-vector.

And then we figure out how to pass that to the handler in irqaction.

To most of the system it is a single irq so it avoids breaking
expectations about what an irq is.

To everything else it is a little odd, and has it's own unique
set of rules (which is good as well).

Eric
