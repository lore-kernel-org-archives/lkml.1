Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053Ab0ARV2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab0ARV2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 16:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755197Ab0ARV2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 16:28:18 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:56685 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab0ARV2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 16:28:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Julia Lawall <julia@diku.dk>
Subject: Re: mcs7830 usb net: "scheduling while atomic" danger?
Date: Mon, 18 Jan 2010 22:23:49 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, Alek Du <alek.du@intel.com>,
       Jacob Pan <jacob.jun.pan@intel.com>,
       Alan Stern <stern@rowland.harvard.edu>
References: <20100118184942.GA10171@rhlx01.hs-esslingen.de> <Pine.LNX.4.64.1001182206190.30446@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1001182206190.30446@ask.diku.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001182223.49764.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/WGm5Oc6NssWUh9Dy40nYjcQUMWAOqR+QmpxL
 eLWjubk18IBmpEZi16ls9YqMId8wdSe/gGoy+9JjTs3e6QrBxc
 Ww7bgssaKX+s1gawC88Ig==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 January 2010, Julia Lawall wrote:
> On Mon, 18 Jan 2010, Andreas Mohr wrote:
> > 
> > Forgive me, but doesn't that mutex_lock()/msleep() (ab)use mean
> > risking a "scheduling while atomic"?
> > (such as discussed in e.g.
> > http://search.luky.org/linux-kernel.2004/msg92817.html )
> > 
> > 
> > And, if that is the case, shouldn't all such cases simply be killed for
> > good via a capable semantic patch?
> 
> The semantic match shown below finds 55 matches.  All but two involve 
> mutex_lock.  Those are in the file 
> /var/linuxes/linux-next/drivers/usb/host/ehci-hub.c
> in the functions ehci_bus_suspend and ehci_hub_control.

That code looks indeed broken as was added las July as part of 331ac6b288d9
"USB: EHCI: Add Intel Moorestown EHCI controller HOSTPCx extensions and
support phy low power mode". The reason that this hasn't triggered is
probably the lack of Moorestown machines in the field.

	Arnd
