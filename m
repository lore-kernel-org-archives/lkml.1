Return-Path: <linux-kernel-owner+w=401wt.eu-S1752024AbXCYSx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbXCYSx7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 14:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbXCYSx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 14:53:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46823 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbXCYSx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 14:53:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
Date: Sun, 25 Mar 2007 20:56:57 +0200
User-Agent: KMail/1.9.5
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <gregkh@suse.de>,
       Tony Luck <tony.luck@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703251428.03382.rjw@sisk.pl> <46068473.9020704@m3y3r.de>
In-Reply-To: <46068473.9020704@m3y3r.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703252056.58914.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 25 March 2007 16:17, Thomas Meyer wrote:
> Rafael J. Wysocki schrieb:
> > On Sunday, 25 March 2007 14:03, Eric W. Biederman wrote:
> >   
> >> Thomas Meyer <thomas@m3y3r.de> writes:
> >>
> >>     
> >>> Eric W. Biederman schrieb:
> >>>       
> >>>> Thomas could you verify the patch below makes the problem go away
> >>>> for you.
> >>>>   
> >>>>         
> >>> The patch solves the problem. I'm writing this after the third suspend
> >>> and resume cycle.
> >>> msi irq stays enabled for libata device:
> >>> cat /sys/devices/pci0000\:00/0000\:00\:1f.2/irq
> >>> 218
> >>>       
> >>> The first suspend to disk is ok. The second suspend to disk has a
> >>> strange behaviour:
> >>> 1.) write pm image
> >>> 2.) the system disable the non-boot cpus again (i guess this happens in
> >>> power_down())
> >>>       
> >
> > Yes, in kernel/power/disk.c:power_down() .
> >
> > Please comment out the disable_nonboot_cpus() in there and retest (but please
> > test the latest Linus' tree).
> >
> >   
> Without disable_nonboot_cpus in power_down the computer powers down
> without the mysterious "wait for the next interrupt" hang.

Do you have CONFIG_NO_HZ set?

Rafael
