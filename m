Return-Path: <linux-kernel-owner+w=401wt.eu-S1759069AbXEaE2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759069AbXEaE2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 00:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755059AbXEaE23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 00:28:29 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:35691 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbXEaE22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 00:28:28 -0400
X-IronPort-AV: i="4.14,596,1170662400"; 
   d="scan'208"; a="376639278:sNHT44138950"
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Matthias Kaehlcke" <matthias.kaehlcke@gmail.com>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/block/ub.c: use list_for_each_entry()
X-Message-Flag: Warning: May contain useful information
References: <20070530084752.GE14284@traven>
	<20070530123840.e54d73c2.zaitcev@redhat.com>
	<a781481a0705301414t4a0c1b2epe5e14b62ec8dc872@mail.gmail.com>
	<20070530160850.0c536d55.zaitcev@redhat.com>
	<adasl9dq4zq.fsf@cisco.com>
	<20070530163236.8bd5640c.zaitcev@redhat.com>
	<adaodk1q3ny.fsf@cisco.com>
	<20070530170530.08a77359.zaitcev@redhat.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 30 May 2007 21:28:22 -0700
In-Reply-To: <20070530170530.08a77359.zaitcev@redhat.com> (Pete Zaitcev's message of "Wed, 30 May 2007 17:05:30 -0700")
Message-ID: <adak5uppqft.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 31 May 2007 04:28:22.0793 (UTC) FILETIME=[1FA9B790:01C7A33C]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > If I just see
 > > 
 > > 	for (pos = list_entry((head)->next, typeof(*pos), member),
 > > 		n = list_entry(pos->member.next, typeof(*pos), member);
 > > 	     &pos->member != (head);
 > > 	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
 > > 
 > > then what am I to think?
 > 
 > You won't catch me writing this kind of crap, so the question is moot.
 > Seriously, a comma operator? Admit it, you just expanded a marcro from
 > list.h by hand. Real people cannot write like that.

Of course I admit it, that is a copy of the definition of list_for_each_safe()
(with just the '/'s removed).  But the point is, if you are writing
something that iterates through a list and deletes entries, you
basically have to write equivalent code.

Just think about how many silly bugs you've written in your life when
(re)implementing linked lists.  By using <linux/list.h>, you avoid all
that, and as a code reviewer that makes my life easier.  It's the same
theory as <linux/kref.h> -- the code is rather trivial (although as
"git log lib/kref.c" shows, not entirely trivial).  But if I see
someone using struct kref, all I have to check is whether she used it
correctly.  I don't have to worry about whether she screwed up the
implementation.

 - R.
