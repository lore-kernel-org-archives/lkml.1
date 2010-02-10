Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab0BJDF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 22:05:58 -0500
Received: from smtp-out.google.com ([216.239.44.51]:35908 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab0BJDF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 22:05:57 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:content-id:x-system-of-record;
	b=k/GH1VCNlKJALNUN9mk60V/wLgq0jxVc6j/1G44tB6MbrABpCuiaWUUNG+Lt50goZ
	Kqxk1OW7kZAYnjVYG9nqQ==
Date: Tue, 9 Feb 2010 19:05:48 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
cc: Neil Brown <neilb@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: differentiate between locking links and
 non-links
In-Reply-To: <2375c9f91002091756h132e81eava8575ffd4e3ad421@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1002091858180.31159@chino.kir.corp.google.com>
References: <19314.1869.847327.15190@notabene.brown> <alpine.DEB.2.00.1002091716580.13999@chino.kir.corp.google.com> <2375c9f91002091756h132e81eava8575ffd4e3ad421@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381004-2060383346-1265770711=:31159"
Content-ID: <alpine.DEB.2.00.1002091858380.31159@chino.kir.corp.google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381004-2060383346-1265770711=:31159
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.00.1002091858381.31159@chino.kir.corp.google.com>

On Wed, 10 Feb 2010, Américo Wang wrote:

> > What happens for hard links such as writing to
> > /sys/devices/block/xxx/queue/scheduler to change an I/O scheduler which
> > requires sd->dep_map and sd->parent->dep_map in sysfs_get_active_two() to
> > pin both?  The call to kobject_del() invokes the destruction that also
> > requires sd->dep_map in sysfs_deactivate() because of the s_active lockdep
> > annotation.
> >
> 
> This is not related with Neil's case at all.
> 
> The I/O scheduler switch case should be a bogus, I am working on
> it. We have more similar cases of cpu hotplug. Trust me, I am working
> on a fix to all of them, this is not as easy as you may think about.
> 

You should be able to reuse Neil's sysfs_dirent_init_lockdep(sd, type) to 
seperate the lock classes for the sd getting pinned in 
sysfs_get_active_two() from sysfs_deactivate(), although using subclasses 
would probably be optimal since there is a clear parent -> child relationship.
--531381004-2060383346-1265770711=:31159--
