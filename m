Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbXGCVC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbXGCVC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757221AbXGCVCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:02:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46390 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427AbXGCVCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:02:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Tue, 3 Jul 2007 23:09:13 +0200
User-Agent: KMail/1.9.5
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>
References: <20070703042916.GA17240@srcf.ucam.org> <200707031709.29968.rjw@sisk.pl> <200707032026.34649.oliver@neukum.org>
In-Reply-To: <200707032026.34649.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707032309.13966.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 3 July 2007 20:26, Oliver Neukum wrote:
> Am Dienstag, 3. Juli 2007 schrieb Rafael J. Wysocki:
> > > > The main reason for deadlocks is because we do a sys_sync() after the
> > > > freeze, which we shouldn't do.
> > > 
> > > So why don't we remove the sys_sync() from freeze_processes() instead?
> > 
> > The patch follows (untested).
> 
> And a further question. The freezer is not atomic. What do you do
> if a task not yet frozen calls sys_sync(), but fuse is already frozen?

Hmm, if the sync is interruptible (I'm not sure), the task should be frozen while
waiting for it to complete.

Otherwise, the freezing of tasks will fail (no deadlock).

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
