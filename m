Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbYJCIg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbYJCIg1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 04:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbYJCIgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 04:36:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751477AbYJCIgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 04:36:15 -0400
Date: Fri, 3 Oct 2008 01:35:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-ide@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH 1/6] Hibernation: Introduce new system state for the
 last phase of hibernation
Message-Id: <20081003013557.42ce685d.akpm@linux-foundation.org>
In-Reply-To: <200809300010.39000.rjw@sisk.pl>
References: <200808290002.55026.rjw@sisk.pl>
	<48D17BBE.5020807@garzik.org>
	<200809300006.24919.rjw@sisk.pl>
	<200809300010.39000.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2008 00:10:37 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Hibernation: Introduce new system state for the last phase of hibernation
> 
> Replace unused SYSTEM_SUSPEND_DISK with a new system_state value
> SYSTEM_HIBERNATE_ENTER that can be used by device drivers to check if
> the system is in the last phase of hibernation.

Violent objections.

We just don't know what this change will do.  It potentially affects
every code site in the kernel which looks at system_state.  We've had
problems in the past with this thing and the more complex we make it,
the worse any future problems will be.  It's Just Bad.

Can we just create a new global?

	extern bool system_entering_hibernation_or_whatever;

?

It'll add four bytes of bss, it'll save *more* than four bytes of
text and it is plainly obviously non-injurious to present and future
code.

hmm?
