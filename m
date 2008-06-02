Return-Path: <linux-kernel-owner+w=401wt.eu-S1758319AbYFBRXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319AbYFBRXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbYFBRXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:23:11 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:54853 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbYFBRXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:23:10 -0400
Date: Mon, 2 Jun 2008 19:22:03 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Message-ID: <20080602172203.GI26854@enneenne.com>
References: <20080601161510.GA26854@enneenne.com> <20080602075113.60d0fdf8@core> <20080602092551.GC26854@enneenne.com> <20080602150257.54692f35@core> <20080602145603.GG26854@enneenne.com> <20080602164840.0dc9cb96@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080602164840.0dc9cb96@core>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: LinuxPPS low-level IRQs timestamps & ldisc
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 04:48:40PM +0100, Alan Cox wrote:
> > I prefere avoid the if clause for getnstimeofday() since each
> > instruction delay may decrease time precision, so:
> 
> Why should everyone else pay the cost of the getnstimeofday they don't
> need ?
> 
> The single conditional check at the start won't make the slightest
> material difference to your accuracy.

In the past we noticed that just moving up the getnstimeofday() of
only one instruction, from:

	port->icount.dcd++;
	getnstimeofday(&ts);

to:

	getnstimeofday(&ts);
	port->icount.dcd++;

the time precision improved from 5ms to 2ms...

However, if you prefere that I add the if clause, I'll do it.

Thanks,

Rodolfo 

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@linux.it
Embedded Systems                     phone:	+39 349 2432127
UNIX programming                     skype:     rodolfo.giometti
