Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbYJCVzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbYJCVzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 17:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbYJCVzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 17:55:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41518 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019AbYJCVzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 17:55:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/6] SATA: Blacklist systems that spin off disks during ACPI power off (rev. 2)
Date: Fri, 3 Oct 2008 23:48:58 +0200
User-Agent: KMail/1.9.9
Cc: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-ide@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <200808290002.55026.rjw@sisk.pl> <20081003054355.e3a3ac79.akpm@linux-foundation.org> <200810031703.32114.rjw@sisk.pl>
In-Reply-To: <200810031703.32114.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810032348.59709.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 3 of October 2008, Rafael J. Wysocki wrote:
> On Friday, 3 of October 2008, Andrew Morton wrote:
> > On Fri, 3 Oct 2008 13:27:18 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > > Can we just create a new global?
> > > > 
> > > > 	extern bool system_entering_hibernation_or_whatever;
> > > 
> > > Yes, we can, but what about:
> > > 
> > > extern bool system_entering_hibernation(void);
> > > 
> > > that will become a static inline in case of !CONFIG_HIBERNATION,
> > > and using a static variable?
> > 
> > Sure, even better.
> 
> OK, I'll respin the entire series, then.

As promised:

---
SATA: Blacklist systems that spin off disks during ACPI power off (rev. 2)

Some notebooks from HP have the problem that their BIOSes attempt to
spin down hard drives before entering ACPI system states S4 and S5.
This leads to a yo-yo effect during system power-off shutdown and the
last phase of hibernation when the disk is first spun down by the
kernel and then almost immediately turned on and off by the BIOS.
This, in turn, may result in shortening the disk's life times.

To prevent this from happening we can blacklist the affected systems
using DMI information, which is implemented by the following series of
patches.

