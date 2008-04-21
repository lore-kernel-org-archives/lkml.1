Return-Path: <linux-kernel-owner+w=401wt.eu-S1760449AbYDURsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760449AbYDURsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 13:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbYDURsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 13:48:13 -0400
Received: from outbound-mail-33.bluehost.com ([69.89.18.153]:56769 "HELO
	outbound-mail-33.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752915AbYDURsM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 13:48:12 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: PCI MSI breaks when booting with nosmp
Date: Mon, 21 Apr 2008 10:43:10 -0700
User-Agent: KMail/1.9.9
Cc: Jean Delvare <jdelvare@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Tejun Heo <htejun@gmail.com>,
       Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Jeff Garzik <jgarzik@pobox.com>
References: <200804172140.02311.jdelvare@suse.de> <200804171308.37328.jbarnes@virtuousgeek.org> <200804172225.14373.jdelvare@suse.de>
In-Reply-To: <200804172225.14373.jdelvare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804211043.10410.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 17, 2008 1:25 pm Jean Delvare wrote:
> Le jeudi 17 avril 2008, Jesse Barnes a écrit :
> > On Thursday, April 17, 2008 12:40 pm Jean Delvare wrote:
> > > Booting with "nosmp" doesn't work on my Thinkpad T60p laptop while
> > > booting with "nosmp pci=nomsi" works. Forcibly disabling PCI MSI
> > > when booting with nosmp fixes the problem. I'm not sure if it's the
> > > correct fix though.
> >
> > Seems like this is fixing the symptom, not the cause.  I'll see if I can
> > reproduce locally...
>
> If it helps, the device that breaks is:
> 00:1f.2 SATA controller: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA
> AHCI Controller (rev 02) i.e. SATA hard disk drive on an Intel ICH7
> controller.

Ok, I see this too on my desktop machine.  It looks like we're not getting 
interrupts setup correctly in the nosmp case.  Still digging through to see 
why though...

Jesse
