Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbZLCMBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbZLCMBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 07:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbZLCMBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 07:01:32 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:57424 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbZLCMBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 07:01:30 -0500
Date: Thu, 3 Dec 2009 13:01:30 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>, Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Message-ID: <20091203120130.GD12943@gundam.enneenne.com>
Mail-Followup-To: "H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Dave Jones <davej@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
	Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>,
	Kay Sievers <kay.sievers@vrfy.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Christoph Hellwig <hch@infradead.org>
References: <1259774329-29663-2-git-send-email-giometti@linux.it> <1259774329-29663-3-git-send-email-giometti@linux.it> <1259774329-29663-4-git-send-email-giometti@linux.it> <1259774329-29663-5-git-send-email-giometti@linux.it> <1259774329-29663-6-git-send-email-giometti@linux.it> <1259774329-29663-7-git-send-email-giometti@linux.it> <1259774329-29663-8-git-send-email-giometti@linux.it> <1259774329-29663-9-git-send-email-giometti@linux.it> <1259774329-29663-10-git-send-email-giometti@linux.it> <4B170204.4080604@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B170204.4080604@zytor.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 09/11] pps: low level IRQ timestamps recording.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 04:10:44PM -0800, H. Peter Anvin wrote:
> On 12/02/2009 09:18 AM, Rodolfo Giometti wrote:
> > Add low level IRQ timestamps recording for x86 (32 and 64 bits)
> > platforms and enable UART clients in order to use it.
> > 
> > This improves PPS precision. :)
> 
> It also invokes getnstimeofday on every single interrupt, including ones
> which have absolutely nothing to do with the PPS, and are potentially
> high volume.  getnstimeofday can be a fairly expensive operation,
> especially if the best available clock is away from the CPU, or it
> requires extensive arithmetic in order to normalize the clock value...

I see, that's why I propose my patches to you: in order to have some
feedbacks for better solutions. :)

Can I add a IRQF_TIMESTAMP in order to ask to the system to record irq
timestamps for particular irq lines? The problem is that I cannot set
that flag at irq_register() time but I have to do it later... it can
be a problem?

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
