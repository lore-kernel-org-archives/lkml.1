Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbYKDAsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbYKDAsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 19:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753630AbYKDAsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 19:48:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43737 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702AbYKDAsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 19:48:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: sleeping function called from invalid context at kernel/sched.c:5558
Date: Tue, 4 Nov 2008 01:53:15 +0100
User-Agent: KMail/1.9.9
Cc: Thomas Meyer <thomas@m3y3r.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, "Moore, Robert" <robert.moore@intel.com>
References: <1225736361.5126.2.camel@localhost.localdomain> <20081103194721.GA16897@elte.hu>
In-Reply-To: <20081103194721.GA16897@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811040153.16514.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 3 of November 2008, Ingo Molnar wrote:
> 
> * Thomas Meyer <thomas@m3y3r.de> wrote:
> 
> > False positive, while suspend/resume-to/from-disk?
> > 
> > [19332.352863] BUG: sleeping function called from invalid context at kernel/sched.c:5558
> > [19332.352866] in_atomic(): 0, irqs_disabled(): 1, pid: 3287, name: pm-hibernate
> > [19332.352869] Pid: 3287, comm: pm-hibernate Tainted: G        W  2.6.28-rc2 #97
> > [19332.352871] Call Trace:
> > [19332.352878]  [<c0436408>] __might_sleep+0xdc/0xe3
> > [19332.352882]  [<c043bbde>] __cond_resched+0x12/0x36
> > [19332.352886]  [<c09d29a8>] _cond_resched+0x27/0x32
> > [19332.352889]  [<c0697d9c>] acpi_ps_complete_op+0x1e0/0x1ef
> > [19332.352892]  [<c069884e>] ? acpi_ps_alloc_op+0x82/0x84
> > [19332.352896]  [<c0689814>] ? acpi_ds_exec_end_op+0x30c/0x370
> > [19332.352899]  [<c069839f>] acpi_ps_parse_loop+0x5f4/0x721
> > [19332.352902]  [<c069779c>] acpi_ps_parse_aml+0x6d/0x267
> 
> Such messages are never false positives, this is a real bug.

Well, not sure.

This is the ACPI AML interpreter executing something with interrupts disabled
due to resume in progress (effectively atomic context).

Thanks,
Rafael
