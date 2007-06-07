Return-Path: <linux-kernel-owner+w=401wt.eu-S933840AbXFGRKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933840AbXFGRKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 13:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757487AbXFGRJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 13:09:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbXFGRJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 13:09:56 -0400
Subject: Re: ext3fs: umount+sync not enough to guarantee metadata-on-disk
From: "Stephen C. Tweedie" <sct@redhat.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Stephen Tweedie <sct@redhat.com>
In-Reply-To: <46682BE7.6080802@rtr.ca>
References: <46680BB8.50404@rtr.ca>
	 <20070607084142.42583639.akpm@linux-foundation.org>
	 <46682BE7.6080802@rtr.ca>
Content-Type: text/plain
Organization: Red Hat UK Ltd, Amberley Place, 107-111 Peascod Street,
	Windsor, Berkshire, SL4 1TE, United Kingdom. Registered in England and
	Wales under Company Registration No. 03798903
Date: Thu, 07 Jun 2007 18:09:41 +0100
Message-Id: <1181236181.10245.16.camel@sisko.scot.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-35.0.2.el4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2007-06-07 at 12:01 -0400, Mark Lord wrote:

> >>    mount /var/lib/mythtv -oremount,ro
> >>    sync
> >>    umount /var/lib/mythtv
> > 
> > Did this succeed?  If the application is still truncating that file, the
> > umount should have failed.
> 
> Actually, what I expect to happen is for the remount,ro
> to block  until the file deletion completes.  But it doesn't.

No -- all that the remount,ro sees is that there's a fd still open for
write.  It has no idea if or when that fd is going to get closed, so it
should fail.  Returning -EBUSY is the only thing it _can_ do: waiting
for the fs to be remountable might wait forever.

So the fs is still writable after that point.

--Stephen


