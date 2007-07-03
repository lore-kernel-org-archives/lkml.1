Return-Path: <linux-kernel-owner+w=401wt.eu-S1759704AbXGCRmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759704AbXGCRmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 13:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755411AbXGCRm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 13:42:26 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:51923 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711AbXGCRmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 13:42:25 -0400
To: rjw@sisk.pl
CC: johannes@sipsolutions.net, stern@rowland.harvard.edu,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       pavel@ucw.cz, mjg59@srcf.ucam.org, paulus@samba.org
In-reply-to: <200707031722.13165.rjw@sisk.pl>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
References: <Pine.LNX.4.44L0.0707031026260.3720-100000@iolanthe.rowland.org> <1183474748.3722.33.camel@johannes.berg> <200707031722.13165.rjw@sisk.pl>
Message-Id: <E1I5mKv-0004TM-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 03 Jul 2007 19:38:49 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Indeed. Actually, one could argue that it's impossible to solve the
> > problem as long as we try to call out to userspace during suspend and
> > need to wait until that's finished, like in the case of sys_sync() and
> > fuse filesystems, and probably other cases. Maybe we should make *those*
> > calls return a failure so that the suspend isn't transparent inside the
> > kernel but is transparent to userspace.
> 
> Well, it generally needs more consideration. :-)
> 
> I think that we should introduce mechanisms that will allow us to notify all
> kernel subsystems, including FUSE and similar, that the system is going to
> enter a sleep state (one of those is the notifier chain introduced recently).

Ugh, please no.

Believe me, fuse is doing _nothing_ out of the ordinary, and should
not need special treatment during suspend/resume.  If suspend itself
is doing something that triggers fuse activity, then that's a bug,
such as the sync() thing that started this thread.

> Then, they may react to such a notification by entering a "suspend" mode
> of operation in which they will return errors from some callbacks that
> otherwise should have succeeded etc.  That depends on the subsystem in
> question.

Sounds horrible.

Why do we need to deal with subsystem interdependencies during
suspend?  Isn't it about saving device state to ram?  That definitely
_should not_ need to trigger anything that touches filesystems or
other subsystems.

Miklos
