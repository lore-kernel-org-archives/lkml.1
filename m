Return-Path: <linux-kernel-owner+w=401wt.eu-S1755457AbZGNQZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbZGNQZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 12:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755423AbZGNQZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 12:25:28 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:51745 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404AbZGNQZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 12:25:27 -0400
X-Greylist: delayed 757 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jul 2009 12:25:27 EDT
X-ASG-Debug-ID: 1247587970-0ecc00580000-xx1T2L
X-Barracuda-URL: http://10.68.76.222:80/cgi-bin/mark.cgi
Date: Tue, 14 Jul 2009 12:12:46 -0400 (EDT)
From: Nicolas Pitre <nico@marvell.com>
X-X-Sender: nico@xanadu.home
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Greg KH <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Lennert Buijtenhek <buytenh@marvell.com>,
       Saeed Bishara <saeed@marvell.com>,
       =?ISO-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>,
       Andrew Morton <akpm@linux-foundation.org>
X-ASG-Orig-Subj: Re: [PATCH] move orion_nand's probe function to .devinit.text
Subject: Re: [PATCH] move orion_nand's probe function to .devinit.text
In-Reply-To: <20090714080947.GA2896@pengutronix.de>
Message-ID: <alpine.LFD.2.00.0907141211260.3138@xanadu.home>
References: <1247345591-22643-18-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-19-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-20-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-21-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-22-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-23-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-24-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-25-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-26-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LFD.2.00.0907131536070.3138@xanadu.home> <20090714080947.GA2896@pengutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811582-754583370-1247587970=:3138"
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1247587970
X-Barracuda-Virus-Scanned: by dakia2.marvell.com at marvell.com
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811582-754583370-1247587970=:3138
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 14 Jul 2009, Uwe Kleine-König wrote:

> Hi Nicolas,
> 
> On Mon, Jul 13, 2009 at 03:37:23PM -0400, Nicolas Pitre wrote:
> > On Sat, 11 Jul 2009, Uwe Kleine-König wrote:
> > 
> > > A pointer to orion_nand_probe is passed to the core via
> > > platform_driver_register and so the function must not disappear when the
> > > .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> > > unbinding and binding a device to the driver via sysfs will result in an
> > > oops as does a device being registered late.
> > > 
> > > An alternative to this patch is using platform_driver_probe instead of
> > > platform_driver_register plus removing the pointer to the probe function
> > > from the struct platform_driver.
> > 
> > For those kind of platform devices I'd prefer the alternative.
> Can I interpret that as your intend to implement and test it?

"Eventually", yes.  This is however a low priority for me.


Nicolas
---1463811582-754583370-1247587970=:3138--
