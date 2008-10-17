Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbYJQUSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbYJQUSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 16:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbYJQUR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 16:17:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:32974 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbYJQUR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 16:17:56 -0400
Date: Fri, 17 Oct 2008 16:17:49 -0400
From: Jeff Layton <jlayton@redhat.com>
To: jim owens <jowens@hp.com>
Cc: Steve French <smfrench@gmail.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-cifs-client] Re: unlink behavior when file is open by
 other process
Message-ID: <20081017161749.1fcbb214@tleilax.poochiereds.net>
In-Reply-To: <48F8ED0E.1060102@hp.com>
References: <524f69650810170809u2df1a309o2f357dc8489c06c6@mail.gmail.com>
	<524f69650810170824x4f9ff975qb03d687c8d3557ff@mail.gmail.com>
	<20081017132714.111e33f9@tleilax.poochiereds.net>
	<524f69650810171041i57ab4466s8cecbdf0268f8417@mail.gmail.com>
	<20081017141013.3aecc88a@tleilax.poochiereds.net>
	<48F8ED0E.1060102@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2008 15:52:46 -0400
jim owens <jowens@hp.com> wrote:

> Jeff Layton wrote:
> 
> > Sure, I'm not disputing whether returning an error on open is right or
> > wrong. The problem is that it's not expected. We've just unlinked the
> > filename and returned success -- there is *no* reason that the create
> > should fail here. An application programmer will (rightfully) consider
> > this a bug.
> 
> I agree that failing the unlink if you can not do it is
> "the right thing to do"... but unless you have some magic
> to prevent anyone else from creating the file between that
> unlink and the create then in fact there is a reason the
> application can see the create fail after unlink succeeds :)

It's all about expectations. If you have your environment set up in
such a way that you allow other processes or clients to race in and
create a file or directory here, then you should be expecting that
the create can fail, when it occurs :)

I just think that we have to strive for _consistent_ behavior from the
kernel. If we allow unlink to return without actually removing the
link, then it may "just work" in most cases. The problem is that it
won't work in some cases and it'll be very hard to predict when that
will be. IMO, that's far worse than just failing the unlink outright.

-- 
Jeff Layton <jlayton@redhat.com>
