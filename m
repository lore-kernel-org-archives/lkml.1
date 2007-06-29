Return-Path: <linux-kernel-owner+w=401wt.eu-S933741AbXF2QdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933741AbXF2QdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 12:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760303AbXF2QdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 12:33:04 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:60044 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757027AbXF2QdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 12:33:03 -0400
Date: Fri, 29 Jun 2007 18:34:22 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070629163422.GP13886@enneenne.com>
References: <20070627224623.GO13886@enneenne.com> <1183018133.1170.46.camel@pmac.infradead.org> <20070628081538.GP13886@enneenne.com> <1183019474.1170.66.camel@pmac.infradead.org> <20070628084003.GQ13886@enneenne.com> <1183031060.1170.145.camel@pmac.infradead.org> <20070628161450.GD13886@enneenne.com> <1183117082.1170.308.camel@pmac.infradead.org> <20070629150813.GM13886@enneenne.com> <1183132548.1170.360.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183132548.1170.360.camel@pmac.infradead.org>
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

On Fri, Jun 29, 2007 at 04:55:47PM +0100, David Woodhouse wrote:

> You missed one. This should be -EFAULT too. And there's not a huge
> amount of point in keeping the access_ok() checks elsewhere, since
> copy_to_user() does that for itself.

Ok, fixed.

> Oh, and I think you do need compat magic for 'struct pps_info' and
> 'struct pps_params' too -- there's a struct timespec hidden deep in
> there, as well as 'unsigned long longpad[3]'.

Gulp! Can you please give me some advices in order to solve also this
problem? Should I use some "ifdef CONFIG_COMPAT" into those
structures? :-o

> Can you explain the 'union pps_timeu'? It seems very odd. How do we know
> which member of the union should be used?

This union is defined by the RFC 2783... we can know which member of
the union should be used by using define PPS_TSFMT_TSPEC for variable
tsformat into function time_pps_fetch().

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
