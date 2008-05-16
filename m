Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbYEPBka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbYEPBka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 21:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYEPBkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 21:40:19 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:46529 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbYEPBkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 21:40:17 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <1204773188.4707.109.camel@caritas-dev.intel.com>
	<20080514205204.GJ30469@redhat.com>
	<1210830110.23707.141.camel@caritas-dev.intel.com>
	<20080516005121.GA6926@redhat.com>
Date: Thu, 15 May 2008 18:35:28 -0700
In-Reply-To: <20080516005121.GA6926@redhat.com> (Vivek Goyal's message of
	"Thu, 15 May 2008 20:51:21 -0400")
Message-ID: <m1skwjghen.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vivek Goyal <vgoyal@redhat.com>
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0030]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH -mm] kexec jump -v9
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> ioapic_suspend() is not putting APICs in Legacy mode and that's why
> we are seeing the issue. It only saves the IOAPIC routing table entries
> and these entries are restored during ioapic_resume().
>
> But I think somebody has to put APICs in legacy mode for normal 
> hibernation also. Not sure who does it. May be BIOS, so that during
> resume, second kernel can get the timer interrupts.

I doubt anything cares in the suspend to ram case. There should just
be a small BIOS trampoline to get back to linux when the processor
restarts.  And you don't need interrupts for any of that. 

Eric
