Return-Path: <linux-kernel-owner+w=401wt.eu-S1946144AbXBPUnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946144AbXBPUnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 15:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946145AbXBPUnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 15:43:18 -0500
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:52103 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946144AbXBPUnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 15:43:17 -0500
Date: Fri, 16 Feb 2007 21:43:36 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com
Message-ID: <20070216204336.GB4641@enneenne.com>
References: <20070216185230.GO8882@enneenne.com> <20070216191207.GC2572@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070216191207.GC2572@flint.arm.linux.org.uk>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 07:12:08PM +0000, Russell King wrote:
> 
> Yuck.  Please.  No.  Doing it this way means you have to modify every
> single serial driver out there which is a mamouth task.
> 
> >  			uart_handle_dcd_change(&up->port, status & UART_MSR_DCD);
> 
> Did you not look to see what's in this helper?  You'll find within here
> the following code:
> 
> #ifdef CONFIG_HARD_PPS
>         if ((port->flags & UPF_HARDPPS_CD) && status)
>                 hardpps();
> #endif
> 
> which should've been a big sign lit up in bright lights in Times Square
> pointing you towards the right place to put your code.

Ok.

> Why not continue to leave it as a decision of the administrator - if
> you want ports to default to having PPS support enabled, change all
> the registration to set UPF_HARDPPS_CD.  But leave the admin with
> the ability to disable it.

Ok.

> This means that PPS support is not available for any port which wasn't
> autoprobed at device discovery time.  That seems quite restrictive.

How I can force probing for a specified uart port?

> Maybe it needs to be coupled with the setting/clearing of UPF_HARDPPS_CD ?

What do you think about? I should enable the PPS support only if the
userland sets the UPF_HARDPPS_CD flag?

Thanks for your comments,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
