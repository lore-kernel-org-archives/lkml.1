Return-Path: <linux-kernel-owner+w=401wt.eu-S1758849AbYGFQW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849AbYGFQW4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 12:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757244AbYGFQWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 12:22:48 -0400
Received: from [194.117.236.238] ([194.117.236.238]:58827 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757234AbYGFQWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 12:22:48 -0400
Date: Sun, 6 Jul 2008 19:22:33 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Frans Pop <elendil@planet.nl>
Subject: Re: [PATCH] parport/ppdev: fix registration of sysctl entries
Message-ID: <20080706192233.5df9c65b@linux360.ro>
In-Reply-To: <20080706081126.GA28946@ZenIV.linux.org.uk>
References: <20080705131924.GA2083@joi>
	<20080705235148.GW28946@ZenIV.linux.org.uk>
	<20080706001148.GX28946@ZenIV.linux.org.uk>
	<20080706040519.GZ28946@ZenIV.linux.org.uk>
	<m1hcb31p8p.fsf@frodo.ebiederm.org>
	<20080706081126.GA28946@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jul 2008 09:11:26 +0100
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Sat, Jul 05, 2008 at 11:49:26PM -0700, Eric W. Biederman wrote:
> > So our choices appear to be.
> > - Change the name in sysctl so each parport device always has a
> > unique name.
> > - Only allow one opener of ppdev for a given port.
> 
> Can't do - it's a legitimate use of ppdev (several userland programs
> multiplexing the sucker).

How in the world would such a thing work?! I imagine one could
read()/write() there and multiplex data, but isn't the whole point of
ppdev to allow non-standard communication (manually flipping control
and data lines)? I've used it for custom hardware.

IMHO, there is one reason ppdev exists: allow both _safe_ and _raw_
access to the parallel port, and a much better alternative to the iopl
stuff.


	Eduard
