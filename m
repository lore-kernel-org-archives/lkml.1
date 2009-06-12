Return-Path: <linux-kernel-owner+w=401wt.eu-S933047AbZFLIOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933047AbZFLIOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 04:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762115AbZFLIOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 04:14:31 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:43218 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762181AbZFLIOa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 04:14:30 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re: [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Fri, 12 Jun 2009 10:15:19 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.30-rc7-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0906112210340.21931-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906112210340.21931-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906121015.19504.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 12. Juni 2009 04:16:10 schrieb Alan Stern:
> What tree constraint?  You mean that the PM core shouldn't allow
> devices to suspend unless all their children are suspended?  Why
> doesn't it still apply?

Because the hardware doesn't need it.

> Remember, when Rafael and I say "suspend" here, we don't mean "go to a
> low-power state".  We mean "the PM core calls the runtime_suspend
> method".  No matter what actions the link hardware may decide to take
> on its own, the PM core will still want to observe the
> all-children-suspended restriction when calling runtime_suspend
> methods.

No. The core if it insists all children be suspended will not use
the hardware's full capabilities.
If it leaves such power saving measures to the drivers, latency
accounting will be wrong.

> > I think there are devices who can be suspended while children are active
> > and devices which can not be. This is an attribute of the device and
> > should be evaluated by the core.
>
> Clearly it should be decided by the driver.  Should there be a bit for
> it in the dev_pm_info structure?

Yes.

	Regards
		Oliver


