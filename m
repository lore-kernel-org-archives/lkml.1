Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbXGCMuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbXGCMuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 08:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbXGCMun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 08:50:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44494 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409AbXGCMum convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 08:50:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Tue, 3 Jul 2007 14:58:15 +0200
User-Agent: KMail/1.9.5
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-pm@lists.linux-foundation.org,
       benh@kernel.crashing.org, nigel@nigel.suspend2.net, mjg59@srcf.ucam.org,
       linux-kernel@vger.kernel.org
References: <20070703042916.GA17240@srcf.ucam.org> <E1I5fug-0003ZS-00@dorka.pomaz.szeredi.hu> <200707031307.41366.oliver@neukum.org>
In-Reply-To: <200707031307.41366.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707031458.16132.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 3 July 2007 13:07, Oliver Neukum wrote:
> Am Dienstag, 3. Juli 2007 schrieb Miklos Szeredi:
> > > > So to summarize, the plan that makes things work with fuse is:
> > > > 
> > > >  - For STR, don't do the freezer thing.
> > > > 
> > > >  - For STD, don't sys_sync() after you froze
> > > > 
> > > > There might be -other- issues, but that should get you through some of
> > > 
> > > At the risk of repeating myself. Character device drivers are written
> > > with the assumption that normal io and suspend/resume do not race
> > > with each other due to the freezer.
> > > What do you intend to do about that?
> > 
> > Oliver, can you please explain your worries in a bit more detail?
> > 
> > I don't claim to know anything about how STR or hibernate works, but
> > neither seem to have any problem with I/O on the fuse device "racing"
> > with them.
> 
> The problem is not with fuse. The problem is generic in nature.
> 
> If you remove the freezer, user space remains active until the last CPU
> goes into suspend. It can do syscalls. Or do you know a clean way to exempt
> only the tasks fuse might use?
> 
> Now device drivers have a guaranteed temporal sequence:
> 
> last io -> suspend() -> resume() [or disconnect()] -> new io
> 
> This is because suspend() is called after the freezer goes into action. If
> you remove the freezer, you need to deal with
> 
> 1. io to suspended devices
> 2. resume() assuming that the device is in the state suspend() left it
> 3. io changing a device's state while suspend is saving it
> 
> and you need to fix this for all device drivers, not just those fuse is
> involved with. Removing the freezer means doing a more or less full
> audit of every driver and additional locking in many drivers.

Agreed.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
