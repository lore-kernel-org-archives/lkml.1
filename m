Return-Path: <linux-kernel-owner+w=401wt.eu-S933479AbXCJQhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933479AbXCJQhs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 11:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933482AbXCJQhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 11:37:48 -0500
Received: from gw.goop.org ([64.81.55.164]:50466 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933479AbXCJQhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 11:37:47 -0500
Message-ID: <45F2DED6.6080500@goop.org>
Date: Sat, 10 Mar 2007 08:37:42 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: question about periodic clocks
References: <45F1ED30.5070402@goop.org>	 <1173516061.24738.1148.camel@localhost.localdomain>	 <45F2D3CE.1060008@goop.org> <1173543844.24738.1178.camel@localhost.localdomain>
In-Reply-To: <1173543844.24738.1178.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> Uuurg. That's ugly. clockevents expect a per CPU timer especially for
> dynamic ticks. If you cannot provide a per cpu timer, then you probably
> need to use the broadcast trick.
>   

Ah, apologies, I'm wrong about this.  I misread the Xen code; the timers
are per-vcpu, but as an implementation detail within the hypervisor it
keeps track of which real cpu is managing that timer.  But logically the
timers are per-vcpu.

    J
