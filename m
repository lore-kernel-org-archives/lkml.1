Return-Path: <linux-kernel-owner+w=401wt.eu-S1754451AbZDPKPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbZDPKPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 06:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbZDPKPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 06:15:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37398 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbZDPKPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 06:15:32 -0400
Date: Thu, 16 Apr 2009 12:15:22 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Corrado Zoccolo <czoccolo@gmail.com>, oliver@neukum.name
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: linux-2.6.30rc1 mouse stuck with usb autosuspend enabled
In-Reply-To: <4e5e476b0904091453m61ec4e81j7cfdef918bb3dfb3@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.0904161210450.10907@twin.jikos.cz>
References: <4e5e476b0904091453m61ec4e81j7cfdef918bb3dfb3@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added Oliver to CC ]

On Thu, 9 Apr 2009, Corrado Zoccolo wrote:

> I found this regression w.r.t. 2.6.29.
> When enabling usb automatic power management for all usb peripherals, with:
> > for i in /sys/bus/usb/devices/*/power/level; do echo auto > $i; done

Well, it's difficult to consider this to be a regression. With default 
settings (USB autosuspend turned off), the system behaves the same way as 
it did before (ie. no mouse autosuspend).

> after 2 seconds of inactivity (my autosuspend threshold), the mouse
> gets stuck under X.

That's because it got suspended, as you have configured it to do so.

> Pushing a mouse button will revive it (and the event is passed to X).

Which is expected behavior.

Your mouse (as many other mice out there) doesn't emit wakeup event on 
movement, it only does on button click. There is nothing kernel can do 
about it. This is one of the reasons why autosuspend is disabled by 
default (other reason being many devices broken beyond hope when it comes 
to waking up).

-- 
Jiri Kosina
SUSE Labs

