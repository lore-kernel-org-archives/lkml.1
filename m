Return-Path: <linux-kernel-owner+w=401wt.eu-S1758902AbYGFRBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902AbYGFRBE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756817AbYGFRAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:00:54 -0400
Received: from [194.117.236.238] ([194.117.236.238]:33439 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756652AbYGFRAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:00:54 -0400
Date: Sun, 6 Jul 2008 20:00:33 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Frans Pop <elendil@planet.nl>
Subject: Re: [PATCH] parport/ppdev: fix registration of sysctl entries
Message-ID: <20080706200033.0b833508@linux360.ro>
In-Reply-To: <20080706170802.61131618@lxorguk.ukuu.org.uk>
References: <20080705131924.GA2083@joi>
	<20080705235148.GW28946@ZenIV.linux.org.uk>
	<20080706001148.GX28946@ZenIV.linux.org.uk>
	<20080706040519.GZ28946@ZenIV.linux.org.uk>
	<m1hcb31p8p.fsf@frodo.ebiederm.org>
	<20080706081126.GA28946@ZenIV.linux.org.uk>
	<20080706192233.5df9c65b@linux360.ro>
	<20080706170802.61131618@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jul 2008 17:08:02 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > IMHO, there is one reason ppdev exists: allow both _safe_ and _raw_
> > access to the parallel port, and a much better alternative to the
> > iopl stuff.
> 
> And various devices support sharing protocols on the parallel port.

But isn't it incorrect to assume that sharing protocols allow multiple
separate users? Why not have an userspace server mux/demux requests?
Told more properly, such devices are multi-context, not multi-user.

AFAICT, this is similar to software mixing on soundcards, where we have
an additional layer mixing (~ multiplexing) outgoing PCM streams.

The parallel port itself is not designed to be shared, so even if the
device supports it, it does not mean we should allow independent
access. We really should have an userspace lib/server to do this.


	Eduard
