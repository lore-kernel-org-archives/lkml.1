Return-Path: <linux-kernel-owner+w=401wt.eu-S1751448AbZJWJQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbZJWJQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 05:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbZJWJQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 05:16:37 -0400
Received: from ozlabs.org ([203.10.76.45]:50473 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbZJWJQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 05:16:36 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Eric Paris <eparis@redhat.com>
Subject: Re: request_module vs. modprobe blacklist (and security subsystem implications)
Date: Fri, 23 Oct 2009 19:46:38 +1030
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       randy.dunlap@oracle.com, andi@firstfloor.org, dhowells@redhat.com,
       akpm@linux-foundation.org
References: <1256137348.4443.39.camel@dhcp231-106.rdu.redhat.com> <200910221626.51170.rusty@rustcorp.com.au> <1256221822.4443.95.camel@dhcp231-106.rdu.redhat.com>
In-Reply-To: <1256221822.4443.95.camel@dhcp231-106.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910231946.39174.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Oct 2009 01:00:22 am Eric Paris wrote:
> > If a userspace program tries some security exploit that has been closed, do
> > you want to warn about it?  Because that seems to be the question here.
> 
> I say yes.  Knowing that malicious activity is taking place, even if it
> didn't hurt anything is useful.

Hi Eric,

Your proposal is troubling for three reasons:

1) You would disable logging for things you actually want logged.
2) What *actually* happens when ssh tries to load ipv6 is that
   "modprobe net-pf-10" gets called.
3) Containing modprobe behavior in one set of config files is really nice.

> > Why should ssh not load IPv6?  Because noone should?  Fine, but there's a
> > difference between "I expect it to do this but I won't let it" and "I don't
> > expect it to do this".
> 
> In this case it's because the admin decided not to allow it.  In this
> case it is 'I expect it to do this, and I know that later it would fail,
> so I don't want to complain that it is failing now.'  I want a way to
> move the failure up, and to allow and admin to stop with the useless
> userspace callouts to modprobe.

No.  I anticipate that in the future you will want to do some fairly
sophisticated filtering.  That does not belong in the kernel unless there
are performance concerns, and I don't think there are here.

There are all kinds of things that can be administratively prohibited, and
it would be nice if my security tools would Just Work with that: I don't think
pushing all the different restrictions into the kernel for SELinux's sake
is the way forward.

> I want a way to make the kernel not upcall at all, if I have that I can
> make SELinux do whatever I want.  If I don't have that, all I can do is
> some post failure fragile userspace filtering.

If the kernel is better at filtering than userspace, that is an SELinux
problem that you should address.

Cheers,
Rusty.
