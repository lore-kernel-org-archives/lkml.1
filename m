Return-Path: <linux-kernel-owner+w=401wt.eu-S1753298AbYIJLDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbYIJLDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 07:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbYIJLDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 07:03:07 -0400
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:45315 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751125AbYIJLDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 07:03:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=EMwEEiXsCPO0iLf65smjX6u6An1txl4RPkbAz0QntcMXSAVFtJeS5j7764Y2thj68FdIyqONEPcUkHZ9r/GzGpLp1N9c9PxQfnkVdedc85G3oNdNKxcg0BowWv3DJDQd8RsjFl5hxcb3rZUdiQggwXDY9c4PODN/0Mhwf3vjHEE=  ;
X-YMail-OSG: Im7C8bAVM1mrpOI83d.KxmIYTVIsawoobTqEzC9x4ePvNbemVMOMvQS1SVGt8PWh5.0..Bonvs95ST7zL_xL2Uq8ugEk8NYH0ebikU2JsyAS9QaJCZw37fKRGdyrWS7S.kGLS4dxlYT1Il5ibSgoNoSy
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Approach #2] [RFC][PATCH] Remove cgroup member from struct page
Date: Thu, 11 Sep 2008 07:02:44 +1000
User-Agent: KMail/1.9.5
Cc: balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       hugh@veritas.com, menage@google.com, xemul@openvz.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <48C66AF8.5070505@linux.vnet.ibm.com> <200809110644.39334.nickpiggin@yahoo.com.au> <20080910200304.fd078007.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080910200304.fd078007.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809110702.45003.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 September 2008 21:03, KAMEZAWA Hiroyuki wrote:
> On Thu, 11 Sep 2008 06:44:37 +1000
>
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > On Wednesday 10 September 2008 11:49, KAMEZAWA Hiroyuki wrote:
> > > On Tue, 9 Sep 2008 18:20:48 -0700
> > >
> > > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2008-09-09
> > > > 21:30:12]: OK, here is approach #2, it works for me and gives me
> > > > really good performance (surpassing even the current memory
> > > > controller). I am seeing almost a 7% increase
> > >
> > > This number is from pre-allcation, maybe.
> > > We really do alloc-at-boot all page_cgroup ? This seems a big change.
> >
> > It seems really nice to me -- we get the best of both worlds, less
> > overhead for those who don't enable the memory controller, and even
> > better performance for those who do.
>
> No trobles for me for allocating-all-at-boot policy.
> My small concern is
>   - wasting page_cgroup for hugepage area.
>   - memory hotplug

In those cases you still waste the struct page area too. I realise that
isn't a good way to justify even more wastage. But I guess it is
relatively low. At least, I would think the users would be more happy to
get a 7% performance increase for small pages! :)


> > Are you expecting many users to want to turn this on and off at runtime?
> > I wouldn't expect so, but I don't know enough about them.
>
> There is no runtime switch. only at boot.

Fine

