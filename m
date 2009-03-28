Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbZC1N4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbZC1N4l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 09:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbZC1N4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 09:56:32 -0400
Received: from vena.lwn.net ([206.168.112.25]:58987 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbZC1N4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 09:56:32 -0400
Date: Sat, 28 Mar 2009 07:56:28 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Ilpo =?ISO-8859-1?B?SuRydmluZW4=?= <ilpo.jarvinen@helsinki.fi>,
       Netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at net/ipv4/tcp_input.c:2927 tcp_ack+0xd55/0x1991()
Message-ID: <20090328075628.3565eb39@bike.lwn.net>
In-Reply-To: <20090328095514.GA2599@gentoox2.trippelsdorf.de>
References: <20090327211202.GA10014@gentoox2.trippelsdorf.de>
	<Pine.LNX.4.64.0903280031080.5904@wrl-59.cs.helsinki.fi>
	<20090328045056.GA2394@gentoox2.trippelsdorf.de>
	<Pine.LNX.4.64.0903280930440.6696@wrl-59.cs.helsinki.fi>
	<20090328095514.GA2599@gentoox2.trippelsdorf.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Mar 2009 10:55:14 +0100
Markus Trippelsdorf <markus@trippelsdorf.de> wrote:

> Yes, you might be right, because running with CONFIG_PROVE_LOCKING and 
> CONFIG_DETECT_SOFTLOCKUP enabled points to a possible bug in the BKL
> removal patches (fasync) by Jonathan Corbet. (I wasn't able so far to
> reproduce the original WARNING.)
> 
> Here is one example:
> 
> =========================================================
> [ INFO: possible irq lock inversion dependency detected ]
> 2.6.29-03321-gbe0ea69 #7
> ---------------------------------------------------------
> swapper/0 just changed the state of lock:
>  (fasync_lock){..+.}, at: [<ffffffff8028a2ac>] kill_fasync+0x24/0x45
> but this lock took another, hard-irq-unsafe lock in the past:
>  (&f->f_lock){--..}

That's not a bug; f_lock will never be taken in IRQ mode.  There's a
fix for the warning in linux-next now; my plan is to get it upstream
before -rc1.

Thanks,

jon

Jonathan Corbet / LWN.net / corbet@lwn.net
