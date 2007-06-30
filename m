Return-Path: <linux-kernel-owner+w=401wt.eu-S1758729AbXF3RFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbXF3RFn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 13:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756162AbXF3RFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 13:05:34 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:41419 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbXF3RFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 13:05:34 -0400
Date: Sat, 30 Jun 2007 19:06:53 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070630170653.GS13886@enneenne.com>
References: <20070627174537.GM13886@enneenne.com> <1182966588.1170.28.camel@pmac.infradead.org> <20070627224623.GO13886@enneenne.com> <1183018133.1170.46.camel@pmac.infradead.org> <20070628081538.GP13886@enneenne.com> <1183019474.1170.66.camel@pmac.infradead.org> <20070628084003.GQ13886@enneenne.com> <1183031060.1170.145.camel@pmac.infradead.org> <20070628161450.GD13886@enneenne.com> <20070630083827.GA21102@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070630083827.GA21102@infradead.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] LinuxPPS (with new syscalls API) - new version
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 30, 2007 at 09:38:27AM +0100, Christoph Hellwig wrote:
> 
> Sorry for coming in that late, but using syscalls for something as
> periphal sounds like a very bad idea to me, and the syscalls aren't
> defined nicely either (e.g. you have an ioctl lookalike).  I'd say
> back to the drawingboard.

PPS API is not only a periphal class. RFC 2783 defines new «functions»
that allow accesso to internal system data collected by some
periferals but these devices are never managed as a tipical char or
block device.

I think implementing parts or full RFC 2783 PPS's functions as
syscalls are not so wrong... IMHO, at least! :)

> And yes, even ioctls are nicer than badly designed syscalls :)

I see, but consider that some PPS devices cannot be always connected
with a filedescriptor since, for example, some PPS devices are
connected by serial lines, other by parallel ports and other
(expecially on embedded systems) are connected by CPU's GPIOs.

An userland programs shouldn't know whenever these devices are
connected, they should only know how to collect PPS data from the
system.

> Also code seems to be odd at least in a few places, e.g. all the access_oks
> and double checks of the ioctl-lookalike commands should go.

I already removed such functions in my latest patches. :)

Thanks,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
