Return-Path: <linux-kernel-owner+w=401wt.eu-S1751253AbXCYTLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253AbXCYTLK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 15:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbXCYTLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 15:11:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46959 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbXCYTLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 15:11:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Meyer <thomas@m3y3r.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
Date: Sun, 25 Mar 2007 21:06:39 +0200
User-Agent: KMail/1.9.5
Cc: Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <gregkh@suse.de>,
       Tony Luck <tony.luck@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070325144838.GD16477@stusta.de> <4606B09C.6030902@m3y3r.de>
In-Reply-To: <4606B09C.6030902@m3y3r.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703252106.40866.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 25 March 2007 19:25, Thomas Meyer wrote:
> Adrian Bunk schrieb:
> > On Sun, Mar 25, 2007 at 01:41:33PM +0200, Thomas Meyer wrote:
> >   
> >> ...
> >> The first suspend to disk is ok. The second suspend to disk has a
> >> strange behaviour:
> >> 1.) write pm image
> >> 2.) the system disable the non-boot cpus again (i guess this happens in
> >> power_down())
> >> 3.) the system doesn't power down.
> >> 4.) pressing any key and the system powers down.
> >> ...
> >>     
> >
> > Is this also present with 2.6.20, or is it a regression?
> >   
> No, this one is not present in 2.6.20 and this error doesn't (head=
> 317ec6cd00f25d05d153a780bc178c5335f320ee) occur with NO_HZ=n and
> HIGH_RES_TIMERS=n
> 
> This error is maybe related with this commit:

Yes, it is, but I'd rather remove the disable_nonboot_cpus() from
power_down() (as Eric suggested) instead of trying to handle the RCU sync
problem here.

This has been caused by my commit 94985134b7b46848267ed6b734320db01c974e72
(swsusp: disable nonboot CPUs before entering platform suspend) that in such a
case should be reverted.

Greetings,
Rafael
