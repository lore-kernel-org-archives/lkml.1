Return-Path: <linux-kernel-owner+w=401wt.eu-S1761956AbZBYQUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761956AbZBYQUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 11:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbZBYQUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 11:20:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753249AbZBYQUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 11:20:31 -0500
Date: Wed, 25 Feb 2009 08:19:24 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Stern <stern@rowland.harvard.edu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [RFC][PATCH 2/2] PM: Rework handling of interrupts
 during suspend-resume
In-Reply-To: <Pine.LNX.4.44L0.0902251027270.3373-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.2.00.0902250818200.3111@localhost.localdomain>
References: <Pine.LNX.4.44L0.0902251027270.3373-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Feb 2009, Alan Stern wrote:

> On Tue, 24 Feb 2009, Rafael J. Wysocki wrote:
> 
> > I think the most important source of level triggered interrupts are PCI
> > devices, so perhaps we can make the PCI PM core use bit 10 of the PCI Device
> > Control register to prevent devices from generating INTx after the drivers'
> > suspend routines have been executed?
> 
> I wish that were true.  As I recall, the original PCI specification did
> not define this bit, and older PCI devices don't support it.  So you
> can't count on being able to supress interrupt generation this way.  

It's definitely a new feature. In fact, I think even the current one makes 
it optional, so even for "new" devices it's very unclear how many of them 
actually support that bit.

			Linus
