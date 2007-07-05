Return-Path: <linux-kernel-owner+w=401wt.eu-S1762663AbXGEUtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762663AbXGEUtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 16:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760698AbXGEUtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 16:49:45 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:52194 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760584AbXGEUto convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 16:49:44 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Thu, 5 Jul 2007 22:49:44 +0200
User-Agent: KMail/1.9.7
Cc: pavel@ucw.cz, paulus@samba.org, stern@rowland.harvard.edu,
       johannes@sipsolutions.net, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <200707052234.30021.oliver@neukum.org> <E1I6YDJ-0001sj-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I6YDJ-0001sj-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707052249.45495.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 5. Juli 2007 schrieb Miklos Szeredi:
> > > Yes, fuse could handle being frozen there.  However that would only
> > > solve part of the problem: an operation waiting for a reply could be
> > > holding a VFS mutex and some other task may be blocked on that mutex.
> > > 
> > > How would you solve freezing those tasks?
> > 
> > OK, you made me reach for literatur on theoretical computer science.
> > 
> > IMHO the range of actions a fuse server is inherently limited.
> > You must never ever block on a lock one of your clients is holding. In
> > this case the limitation is not influenced by the freezer.
> 
> Obviously.  But I wasn't about the server trying to acquire a lock
> held by a client.  I was talking about a client trying to acquire a
> lock held by _another_ client.
> 
> If this coincides with the server (or some other task which the server
> is depending on) being frozen before the clients, the freezer has a
> problem.

True, but that case can only happen if servers are frozen before clients.
You don't need a full dependency graph. A simple set sequence of two
classes of tasks will do.

	Regards
		Oliver

