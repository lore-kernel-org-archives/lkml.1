Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab0BJDTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 22:19:13 -0500
Received: from smtp-out.google.com ([216.239.44.51]:41236 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab0BJDTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 22:19:11 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=jwPP3+w61SVm+2s0EXlGesWXNbDQaypjhGB589Tbh6ACONHB9Z6yitUKd3M2kry3A
	hzL+y2+dbTylmjr0HUnpw==
Date: Tue, 9 Feb 2010 19:19:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
cc: Neil Brown <neilb@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: differentiate between locking links and
 non-links
In-Reply-To: <2375c9f91002091914l6738a06eq5cba5f5fbf08976a@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1002091917230.31159@chino.kir.corp.google.com>
References: <19314.1869.847327.15190@notabene.brown> <alpine.DEB.2.00.1002091716580.13999@chino.kir.corp.google.com> <2375c9f91002091756h132e81eava8575ffd4e3ad421@mail.gmail.com> <alpine.DEB.2.00.1002091858180.31159@chino.kir.corp.google.com>
 <2375c9f91002091914l6738a06eq5cba5f5fbf08976a@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381004-991885737-1265771945=:31159"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381004-991885737-1265771945=:31159
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 10 Feb 2010, Américo Wang wrote:

> > You should be able to reuse Neil's sysfs_dirent_init_lockdep(sd, type) to
> > seperate the lock classes for the sd getting pinned in
> > sysfs_get_active_two() from sysfs_deactivate(), although using subclasses
> > would probably be optimal since there is a clear parent -> child relationship.
> 
> Yeah, basically, my fix is also adding a separate lockdep class, but
> at a different
> level. I will send the fix as soon as I finish it.
> 

They shouldn't be entirely seperate classes for your "mutable" cases since 
there will always be a parent -> child relationship, they should be 
subclasses under the same lockclass at a SINGLE_DEPTH_NESTING level.
--531381004-991885737-1265771945=:31159--
