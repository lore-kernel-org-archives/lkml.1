Return-Path: <linux-kernel-owner+w=401wt.eu-S1758794AbXIBVqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794AbXIBVqs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 17:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbXIBVqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 17:46:39 -0400
Received: from hu-out-0506.google.com ([72.14.214.227]:26596 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbXIBVqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 17:46:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=E8ON+OHPGbQktIxxrg+j/aq1+DBhSRrrsEcor41nnZqQIX9N4e9NHPqI2jHc0Z0xhsv5LsSWAH55lEfV7ubKAlnruGwMTRZGpKnHf6xg806KRwnwxjZ487pWYBcfLQBRcXCCIW2k2On3YeGDe5/8mRvn1v8yV77vM1TnA7po+48=
Date: Mon, 3 Sep 2007 01:46:31 +0400
To: FD Cami <francois.cami@free.fr>
Cc: Alessandro Suardi <alessandro.suardi@gmail.com>,
       charles gagalac <charles.gagalac@gmail.com>,
       daryll q <daryll_26m@yahoo.com.ph>, linux-kernel@vger.kernel.org
Subject: Re: Hang in 2.6.23-rc5
Message-ID: <20070902214631.GA1892@martell.zuzino.mipt.ru>
References: <994260.18490.qm@web57301.mail.re1.yahoo.com> <6cf66ee10709021205u7d57b93fv777f414dbba4373f@mail.gmail.com> <5a4c581d0709021338s1e9e0dc0md490a032781b60e8@mail.gmail.com> <20070902232939.f2c8acbb.francois.cami@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070902232939.f2c8acbb.francois.cami@free.fr>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 02, 2007 at 11:29:39PM +0200, FD Cami wrote:
> On Sun, 2 Sep 2007 22:38:28 +0200
> "Alessandro Suardi" <alessandro.suardi@gmail.com> wrote:
> 
> > On 9/2/07, charles gagalac <charles.gagalac@gmail.com> wrote:
> > > On 9/2/07, daryll q wrote:
> > > > Upgraded my kernel from 2.6.23-rc2 to 2.6.23-rc5.
> > > >
> > > >  System hangs (caps lock and scroll lock leds are both flashing).
> > > >
> > > >  It *randomly* happens but most of the time during after login to
> > > > KDE.
> > > >
> > > >  I have not investigated it yet because I have not tried doing
> > > > it  before.
> > > >
> > > >  Also the system is really not responding so I can't do much..
> > > > Just hope it blue screen so I can send the error code easily :)
> > >
> > > i experienced hangs, with the flashing caps and scroll locks as
> > > you've described, in a few of my later pulls prior to rc5.  i
> > > couldn't reproduce the hangs and my logs didn't show evidence of a
> > > problem.  my system under rc5, so far, hasn't hung on me.
> > >
> > > charles
> > 
> > Oh, I thought I was the only one. I also had a single hang+flashing
> >  Caps & Scroll Lock with -rc5, but haven't had one since.
> > 
> > I had VMWare Player modules loaded at the time though, and I
> >  recently rebuilt them with the any-any-patch-113 (earlier versions
> >  would not build with very recent kernels).
> > 
> > -rc4-git2 and -git3 never hung even with VMWare modules loaded.
> > 
> > So I disabled the autoload of VMWare stuff. The problem has not
> >  reproduced so far. My system is a Dell D610, running updated
> >  Fedora 7, with Intel 915GM video chipset.
> 
> I've just had a kernel panic, running a vanilla 2.6.23-rc5, no
> proprietary modules loaded, running X11 under moderate load.
> 2.6.23-rc[2-4] have been rock solid on the same box. I've reverted
> to rc4 for now.

Try this from net-2.6 tree:

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -560,7 +560,7 @@ static u32 tcp_rto_min(struct sock *sk)
 	struct dst_entry *dst = __sk_dst_get(sk);
 	u32 rto_min = TCP_RTO_MIN;
 
-	if (dst_metric_locked(dst, RTAX_RTO_MIN))
+	if (dst && dst_metric_locked(dst, RTAX_RTO_MIN))
 		rto_min = dst->metrics[RTAX_RTO_MIN-1];
 	return rto_min;
 }
