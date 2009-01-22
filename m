Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbZAVXcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbZAVXcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 18:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbZAVXcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 18:32:00 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34698 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558AbZAVXb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 18:31:59 -0500
Date: Thu, 22 Jan 2009 18:31:15 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Steve French <smfrench@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-cifs-client] [PATCH] cifs: wrap cifs_dnotify_thread in 
 CONFIG_BROKEN
Message-ID: <20090122183115.1cef1b53@tleilax.poochiereds.net>
In-Reply-To: <524f69650901221513m7857488by6713eca64ee31681@mail.gmail.com>
References: <1232642078-9717-1-git-send-email-jlayton@redhat.com>
	<20090122210655.GA6065@infradead.org>
	<524f69650901221513m7857488by6713eca64ee31681@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2009 17:13:37 -0600
Steve French <smfrench@gmail.com> wrote:

> The thread may be renamed/rewritten etc. - but we badly need to finish
> the dnotify / inotify code ... removing the start on this that someone
> wrote in the past isn't getting us any closer to this.
> 
> dnotify/inotify support was added to Linux in the first place because
> Samba used it to handle this common operation (it is commonly used by
> OTHER cifs clients) ... but none of the Linux cluster/network file
> systems have had time to finish the code ... we need to finish this -
> the network protocol portion of this is now well documented (and we
> presumably will need a thread to process the dnotify multishot
> notification responses so we don't clog up the demultiplex thread
> waiting on kde and gnoe)
> 

Removing this kthread won't measurably move us farther away from that
goal either.

It's currently under CONFIG_CIFS_EXPERIMENTAL, which would be fine if
it actually did something. It doesn't though -- it just wakes up tasks
that don't need to be woken up.

I have no issue with a kthread that does useful work, but why not remove
this kthread out of the mainline code for now and just plan to put it
back when it actually has something useful to do?

The patch that removes it will live in perpetuity in git. It'll be a
trivial matter to revert it when you're ready to have the kthread do
real work.

-- 
Jeff Layton <jlayton@redhat.com>
