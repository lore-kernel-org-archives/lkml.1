Return-Path: <linux-kernel-owner+w=401wt.eu-S1753652AbZK2A3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbZK2A3E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 19:29:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbZK2A3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 19:29:03 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34905 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485AbZK2A3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 19:29:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ferenc Wagner <wferi@niif.hu>
Subject: Re: [linux-pm] intermittent suspend problem again
Date: Sun, 29 Nov 2009 01:29:25 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc8-rjw; KDE/4.3.3; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, yakui.zhao@intel.com,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <87fx93pwv2.fsf@tac.ki.iif.hu> <200911182313.14092.rjw@sisk.pl> <87d4324gp7.fsf@tac.ki.iif.hu>
In-Reply-To: <87d4324gp7.fsf@tac.ki.iif.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911290129.25505.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 November 2009, Ferenc Wagner wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > On Wednesday 18 November 2009, Ferenc Wagner wrote:
> >
> >> Ferenc Wagner <wferi@niif.hu> writes:
> >> 
> >>> Since I've instrumented s2disk and the hibernation path, no freeze
> >>> happened during hibernating the machine.
> >> 
> >> Not until I removed the delays from hibernation_platform_enter(), which
> >> were put there previously to get step-by-step feedback.  Removing them
> >> again resulted in a freeze in short course, maybe just two hibernations
> >> later.  The instrumentation shows it stuck in dpm_suspend_start(PMSG_HIBERNATE).
> >> Does it mean that some device driver is at fault?
> >
> > A driver or one of the platform hooks.
> >
> >> I'll check if it always fails at the same point (although tracing into
> >> dpm_suspend_start isn't pure fun because of the multitude of devices it
> >> loops over).  Is there any way to get printk output from that phase?
> >
> > Compile with CONFIG_PM_VERBOSE (it does mean exactly that).
> 
> The last message now was:
> 
> e100: 0000:02:08.0: hibernate, may wakeup
> 
> Looks like hibernating the e100 driver is unstable.

Can you verify that by trying to hibernate without the e100 driver?

Rafael
