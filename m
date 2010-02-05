Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806Ab0BEJek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 04:34:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932408Ab0BEJej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 04:34:39 -0500
Message-ID: <4B6BE6BC.4070506@redhat.com>
Date: Fri, 05 Feb 2010 17:37:00 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>, akpm@linux-foundation.org
Subject: Re: [Patch v2] sysfs: add lockdep class support to s_active
References: <20100205064622.4141.72867.sendpatchset@localhost.localdomain> <m1iqachx8k.fsf@fess.ebiederm.org>
In-Reply-To: <m1iqachx8k.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Amerigo Wang <amwang@redhat.com> writes:
> 
>> Recently we met a lockdep warning from sysfs during s2ram or cpu hotplug.
>> As reported by several people, it is something like:
> 
> The interesting case is the cpu hotplug is actually a problem.  It isn't
> useful to get a complaint about the non-problems code paths triggered
> by pm.  However my earlier review spotted a real deadlock case.  Where
> in one of the sysfs attributes we iterate over the list of online cpus
> and that appeared to an attribute that removing a cpu would remove
> from sysfs...
> 

You are referring this one:
http://marc.info/?l=linux-kernel&m=126474021428905&w=2
?

Hmm, yeah, I missed that the lock it is holding is not s_active, thus so
not be the case we are trying to fix here.

Thanks for pointing this out.
