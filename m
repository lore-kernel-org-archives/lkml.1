Return-Path: <linux-kernel-owner+w=401wt.eu-S1760456AbZJNVRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760456AbZJNVRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 17:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760194AbZJNVRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 17:17:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40564 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753363AbZJNVRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 17:17:23 -0400
Date: Wed, 14 Oct 2009 22:16:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Fulghum <paulkf@microgate.com>, Boyan <btanastasov@yahoo.co.uk>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
Message-ID: <20091014221633.1b865651@lxorguk.ukuu.org.uk>
In-Reply-To: <20091014195215.GA12936@redhat.com>
References: <4AD4F548.2030506@microgate.com>
	<alpine.LFD.2.01.0910131514100.3404@localhost.localdomain>
	<1255478932.19056.24.camel@localhost.localdomain>
	<4AD51D6B.7010509@microgate.com>
	<alpine.LFD.2.01.0910131744590.3404@localhost.localdomain>
	<20091014125846.1a3c8d40@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0910140804180.6146@localhost.localdomain>
	<alpine.LFD.2.01.0910140925440.6146@localhost.localdomain>
	<20091014182037.GA10076@redhat.com>
	<alpine.LFD.2.01.0910141131050.6146@localhost.localdomain>
	<20091014195215.GA12936@redhat.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Assuming that we should not check all CPUs. And in this case perhaps we can
> even do something like
> 
> 	if (!delayed_work_pending() &&
> 	    get_wq_data()->current_work != dwork)
> 		return;
> 
> but this needs barriers, and run_workqueue() needs mb__before_clear_bit().

Linus correctly said that we got into the mess because the locking was
too clever before. At this point the mutex approach seems to be rather
preferable to the other approaches which are at least as "clever" as the
current locking
