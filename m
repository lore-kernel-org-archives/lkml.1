Return-Path: <linux-kernel-owner+w=401wt.eu-S1758342AbZDSBDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342AbZDSBDw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 21:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbZDSBDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 21:03:41 -0400
Received: from smtp.knology.net ([24.214.63.101]:56468 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858AbZDSBDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 21:03:40 -0400
Subject: Re: [PATCH net-next] myri10ge: allow per-board firmware overriding
From: David Dillow <dave@thedillows.org>
To: Brice Goglin <brice@myri.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linux Network Development list <netdev@vger.kernel.org>
In-Reply-To: <49EA1DAC.1000602@myri.com>
References: <49E7239B.4000309@myri.com>
	 <20090417095038.49b745bf@dhcp-lab-109.englab.brq.redhat.com>
	 <49EA1DAC.1000602@myri.com>
Content-Type: text/plain
Date: Sat, 18 Apr 2009 20:56:57 -0400
Message-Id: <1240102617.5342.6.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-04-18 at 20:36 +0200, Brice Goglin wrote:
> Stanislaw Gruszka wrote:
>
> > This would help in situation like this - admin will not have to thinking
> > about boards initialization ordering. Besides some other drivers (like MTD
> > cmd partitions) use own parsing for similar things, I think would be
> > nice to unify things. What You think?
> >   
> 
> We actually thought about supporting "eth2:fwname1,eth0:fwname2". But it
> might be hard to implement in this case due to udev possible renaming
> interfaces and this firmware names being needed *before* the renaming.
> So yes, an automatic way to handle such parameter strings might be good,
> but maybe not in this exact case.

It seems like this could be done in user space, using the PCI bus ID as
a key to select the firmware. The uevent identifies which device is
requesting the firmware, so some modification to /lib/udev/firmware.sh
should do it.

Not that I really want to encourage relying on the bus ID being part of
the path to the firmware files, as if no one uses it, it makes it easier
to cache firmware files for multiple devices, but that's work for
another day and the ABI is already set anyway...

Dave

