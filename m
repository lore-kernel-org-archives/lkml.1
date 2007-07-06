Return-Path: <linux-kernel-owner+w=401wt.eu-S1762650AbXGFHv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762650AbXGFHv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 03:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755783AbXGFHvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 03:51:49 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:48970 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbXGFHvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 03:51:49 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Fri, 6 Jul 2007 09:51:47 +0200
User-Agent: KMail/1.9.7
Cc: rjw@sisk.pl, nigel@suspend2.net, pavel@ucw.cz, benh@kernel.crashing.org,
       mjg59@srcf.ucam.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <20070703042916.GA17240@srcf.ucam.org> <200707060940.23248.rjw@sisk.pl> <E1I6iPL-0003Hj-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I6iPL-0003Hj-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707060951.47555.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 6. Juli 2007 schrieb Miklos Szeredi:
> > > You're missing the point. I'm arguing that a sync from within the freezer 
> > > should guarantee that there is no data loss.
> > 
> > Well, it should, but it doesn't ...
> > 
> > Moreover, if FUSE implements syncing, then the sync from within the freezer
> > will almost certainly deadlock.
> 
> Rafael, think positively: by the time fuse implements sync(), the
> freezer will be long gone ;)

Now you are entering really dangerous territory.
If you can implement a meaningfull sync method, you must have dirty
pages in the page cache. That means you are in the page freeing path
of the vm. Then we are in real trouble. Don't even think about it.

As far as suspend/hibernate is concerned, get yourself on the new
notifying chain and revert to synchronous operations when notified.

	Regards
		Oliver

