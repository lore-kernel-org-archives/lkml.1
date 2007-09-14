Return-Path: <linux-kernel-owner+w=401wt.eu-S1753247AbXINJMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbXINJMp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 05:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbXINJMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 05:12:34 -0400
Received: from dresden.studentenwerk.mhn.de ([141.84.225.229]:53202 "EHLO
	email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751876AbXINJMc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 05:12:32 -0400
From: Wolfgang Walter <wolfgang.walter@studentenwerk.mhn.de>
Organization: Studentenwerk =?iso-8859-1?q?M=FCnchen?=
To: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [patch] sunrpc: make closing of old temporary sockets work (was: problems with lockd in 2.6.22.6)
Date: Fri, 14 Sep 2007 11:12:30 +0200
User-Agent: KMail/1.9.5
Cc: Neil Brown <neilb@suse.de>, trond.myklebust@fys.uio.no,
       netdev@vger.kernel.org, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
References: <200709121407.11151.wolfgang.walter@studentenwerk.mhn.de> <200709122140.57783.wolfgang.walter@studentenwerk.mhn.de> <20070912195512.GC13792@fieldses.org>
In-Reply-To: <20070912195512.GC13792@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709141112.30634.wolfgang.walter@studentenwerk.mhn.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 12. September 2007 21:55 schrieb J. Bruce Fields:
> On Wed, Sep 12, 2007 at 09:40:57PM +0200, Wolfgang Walter wrote:
> > On Wednesday 12 September 2007, J. Bruce Fields wrote:
> > > On Wed, Sep 12, 2007 at 04:14:06PM +0200, Neil Brown wrote:
> > > > So it is in 2.6.21 and later and should probably go to .stable for
> > > > .21 and .22.
> > > >
> > > > Bruce:  for you :-)
> > >
> > > OK, thanks!  But, (as is alas often the case) I'm still confused:
> > > >  		if (!test_and_set_bit(SK_OLD, &svsk->sk_flags))
> > > >  			continue;
> > > > -		if (atomic_read(&svsk->sk_inuse) || test_bit(SK_BUSY,
> > > > &svsk->sk_flags)) +		if (atomic_read(&svsk->sk_inuse) > 1
> > > > +		    || test_bit(SK_BUSY, &svsk->sk_flags))
> > > >  			continue;
> > > >  		atomic_inc(&svsk->sk_inuse);
> > > >  		list_move(le, &to_be_aged);
> > >
> > > What is it that ensures svsk->sk_inuse isn't incremented or SK_BUSY set
> > > after that test?  Not all the code that does either of those is under
> > > the same serv->sv_lock lock that this code is.
> >
> > This should not matter - SK_CLOSED may be set at any time.
> >
> > svc_age_temp_sockets only detaches the socket, sets SK_CLOSED and then
> > enqueues it. If SK_BUSY is set its already enqueued and svc_sock_enqueue
> > ensures that it is not enqueued twice.
>
> Oh, got it.  And the list manipulation is safe thanks to sv_lock.  Neat,
> thanks.  Can you verify that this solves your problem?

Patch works fine here.

Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
