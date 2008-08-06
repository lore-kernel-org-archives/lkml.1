Return-Path: <linux-kernel-owner+w=401wt.eu-S1764433AbYHFJiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764433AbYHFJiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 05:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbYHFJh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 05:37:59 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:48229 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384AbYHFJh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 05:37:58 -0400
In-Reply-To: <20080805201535.GC27192@kroah.com>
To: Greg KH <greg@kroah.com>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface	for	on
 access scanning
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: tvrtko.ursulin@sophos.com
Date: Wed, 6 Aug 2008 10:37:06 +0100
X-MIMETrack: S/MIME Sign by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 06/08/2008 10:37:54,
	Serialize by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 06/08/2008 10:37:54,
	Serialize complete at 06/08/2008 10:37:54,
	S/MIME Sign failed at 06/08/2008 10:37:54: The cryptographic key was not
 found,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 06/08/2008 10:37:08,
	Serialize complete at 06/08/2008 10:37:08
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080806093800.1428B316899@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote on 05/08/2008 21:15:35:

> > > > Perf win, why bothering looking for malware in /proc when it can't
> > > > exist?  It doesn't take longer it just takes time having to do
> > > > 
> > > > userspace -> kernel -> userspace -> kernel -> userspace
> > > > 
> > > > just to cat /proc/mounts, all of this could probably be alliviated 
if we
> > > > cached access on non block backed files but then we have to come 
up with
> > > > a way to exclude only nfs/cifs.  I'd rather list the FSs that 
don't need
> > > > scanning every time than those that do....
> > > 
> > > How long does this whole process take?  Seriously is it worth the 
added
> > > kernel code for something that is not measurable?
> > 
> > Is it worth having 2 context switches for every open when none are
> > needed?  I plan to get numbers on that.
> 
> Compared to the real time it takes in the "virus engine"?  I bet it's
> totally lost in the noise.  Those things are huge beasts with thousands
> to hundreds of thousands of context switches.

No, because we are talking about a case here where we don't want to do any 
scanning. We want to detect if it is procfs (for example) as quickly as 
possible and don't do anything. Same goes for any other filesystem where 
it is not possible to store arbitrary user data.
 
> > > > In kernel caching is clearly a huge perf win.
> > > 
> > > Why?  If the cache is also in userspace, it should be the same, 
right?
> > 
> > In kernel cache has 0 context switches for every open.  Userspace
> > caching has 2.  Every open has to block, switch to the context of the
> > userspace client/cache, get that decisions, and then switch back to 
the
> > original process.
> 
> Again, compared to what?  If you in userspace are doing big complex
> things, such an overhead is trivial.

Again similar thing as above - In case of a cache we are not doing complex 
things.

So I think you can't argue that because scanning is slow everything else 
has to go to userspace. On a typical running system scanning is 
exceptional and everything else benefits from being in the fast path.

Tvrtko


Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

