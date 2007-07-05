Return-Path: <linux-kernel-owner+w=401wt.eu-S1760351AbXGETjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760351AbXGETjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 15:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757924AbXGETjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 15:39:01 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:48513 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576AbXGETjA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 15:39:00 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Thu, 5 Jul 2007 21:38:56 +0200
User-Agent: KMail/1.9.7
Cc: pavel@ucw.cz, paulus@samba.org, stern@rowland.harvard.edu,
       johannes@sipsolutions.net, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <20070705115400.GF3984@ucw.cz> <E1I6Q73-0000Xi-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I6Q73-0000Xi-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707052138.56920.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 5. Juli 2007 schrieb Miklos Szeredi:
> > > Actually fuse allows SIGKILL, because it's always fatal, and the
> > > syscall may not be restarted.
> > 
> > I think you want to stick try_to_freeze() at the same places where you
> > do SIGKILL handling. That should solve the 'syslogd is unfreezeable'
> > problem.
> 
> I could, but it would not solve the general problem.  Namely, that the
> presence of fuse imposes a certain ordering in which userspace tasks
> have to be frozen.  And it is not possible to know this ordering.

Actually, why do you need this? There is no absolute need that you
finish the request. You must either finish the request or let yourself
be frozen.

A quick look through fuse reveals principally request_wait_answer()
And maybe a few other places. Is there some hidden reason you cannot
handle being frozen here?

	Regards
		Oliver
