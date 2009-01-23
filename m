Return-Path: <linux-kernel-owner+w=401wt.eu-S1763315AbZAWBcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763315AbZAWBcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:32:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760931AbZAWBRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:17:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39602 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760923AbZAWBRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:17:37 -0500
Date: Thu, 22 Jan 2009 20:17:19 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Steve French <smfrench@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-cifs-client@lists.samba.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [linux-cifs-client] [PATCH] cifs: wrap cifs_dnotify_thread in 
 CONFIG_BROKEN
Message-ID: <20090122201719.4d1f0b75@tleilax.poochiereds.net>
In-Reply-To: <524f69650901221556q62726c9fg15d9819dca1248fe@mail.gmail.com>
References: <1232642078-9717-1-git-send-email-jlayton@redhat.com>
	<20090122210655.GA6065@infradead.org>
	<524f69650901221513m7857488by6713eca64ee31681@mail.gmail.com>
	<20090122183115.1cef1b53@tleilax.poochiereds.net>
	<524f69650901221541x63ae3940oaaa75f12a3e2ff97@mail.gmail.com>
	<524f69650901221556q62726c9fg15d9819dca1248fe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2009 17:56:09 -0600
Steve French <smfrench@gmail.com> wrote:

> One of the obvious reasons that we could throw away the idea of a cifs
> dnotify thread for cifs is if we could guarantee that all of the
> functions in include/linux/fsnotify.h are nonblocking.  If the
> fsnotify.h worker functions are nonblocking then we could safely
> process all of the notify responses in cifs_demultiplex_thread (since
> we wouldn't have to queue them) without clogging up response
> processing for the socket.   Note that notify responses are unusual -
> they don't have an application thread waiting on them ("multishot"
> responses) typically (there is only one other type of SMB response
> that does not have an application thread associated with it).
> 

I'm not arguing against the need for a kthread to handle notifications.
Heck, I'm even ok with more than one thread if it's necessary.

We simply don't have such an implementation today. Until we do, this
kthread is just dead weight. There's simply no need to keep this in
place until we have working code that uses it.

-- 
Jeff Layton <jlayton@redhat.com>
