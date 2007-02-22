Return-Path: <linux-kernel-owner+w=401wt.eu-S1945960AbXBVI76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945960AbXBVI76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 03:59:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945961AbXBVI76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 03:59:58 -0500
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:44387 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945960AbXBVI75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 03:59:57 -0500
Date: Thu, 22 Feb 2007 10:00:20 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       linuxpps@ml.enneenne.com
Message-ID: <20070222090020.GD23916@enneenne.com>
References: <20070216185230.GO8882@enneenne.com> <45DA6354.3000305@zytor.com> <20070221120426.GJ4641@enneenne.com> <200702220051.49106.zippel@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702220051.49106.zippel@linux-m68k.org>
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

On Thu, Feb 22, 2007 at 12:51:48AM +0100, Roman Zippel wrote:
> Hi,
> 
> On Wednesday 21 February 2007 13:04, Rodolfo Giometti wrote:
> 
> > RFC simply doesn't consider the fact that you can have a PPS source
> > __without__ a filedes connected with, and a single filedes is
> > considered __always__ connected with a single PPS source.
> 
> That's not entirely true. It doesn't say that pps_handle_t must be a file 
> descriptor and it leaves the option for the argument to time_pps_create() not 
> to be a file descriptor as well.

Yes. In fact that's my solution!

The problem is that "pps_handle_t" is forced by the RFC to be a scalar
and _not_ a generic (and opaque) type. I suppose that since right now
such handler was simply the filedes of the serial/parallel port
connected with the GPS antenna. But this is not always the case. As
already told the GPS antenna can be connected with the serial line
while the PPS signal is not, so NTPD should always open the serial
port to read GPS data but it must not use such filedes for the
time_pps_create().

My support try to resolve this problem with minor changes in both RFC
and NTPD code.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
