Return-Path: <linux-kernel-owner+w=401wt.eu-S933362AbYBMXbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933362AbYBMXbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 18:31:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760632AbYBMXb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 18:31:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:64448 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003AbYBMXb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 18:31:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org, benh@kernel.crashing.org
Subject: Re: [Patch 0/2] powerpc: avoid userspace poking to legacy ioports
Date: Thu, 14 Feb 2008 00:07:37 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20080118.763038)
Cc: Christian Krafft <krafft@de.ibm.com>, parabelboi@bopserverein.de,
       linux-kernel@vger.kernel.org
References: <20080213182800.5c6940a8@de.ibm.com> <20080213183506.7f3e3145@de.ibm.com> <1202935374.7296.44.camel@pasglop>
In-Reply-To: <1202935374.7296.44.camel@pasglop>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802140007.38407.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18YQmZ+ZSTzTZFOa02/mdBaKWH6cDhMCzwrHue
 XC3o+zT7TSgCBN2/rkXCO2+D+g50DwyhroUKlurjslIez0OQ/Z
 YI7PCXyUXw81YymIv+svQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 February 2008, Benjamin Herrenschmidt wrote:
> On Wed, 2008-02-13 at 18:35 +0100, Christian Krafft wrote:
> > sensors_detect crashes kernel on PowerPC, as it pokes directly to memory.
> > This patch adds a check_legacy_ioports to read_port and write_port.
> > It will now return ENXIO, instead of oopsing.
> > 
> > Signed-off-by: Christian Krafft <krafft@de.ibm.com>
> 
> The problem is that this prevents using /proc/ioports to access PCI
> IO space, which might be useful.
> 
> I hate that sensors_detect.. or for that matter any other userland code
> that pokes random ports like that. It should die.

What kind of Oops do you get? Is it because the ioport area is not
ioremapped at all or do you get a machine check? If there is no
mapping, we could possibly change inb and outb do deal with that.

	Arnd <><
