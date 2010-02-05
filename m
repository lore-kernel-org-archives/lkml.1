Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab0BEJ7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 04:59:53 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:36750 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767Ab0BEJ7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 04:59:51 -0500
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>, akpm@linux-foundation.org
Subject: Re: [Patch v2] sysfs: add lockdep class support to s_active
References: <20100205064622.4141.72867.sendpatchset@localhost.localdomain>
	<m1iqachx8k.fsf@fess.ebiederm.org> <4B6BE6BC.4070506@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 05 Feb 2010 01:59:40 -0800
In-Reply-To: <4B6BE6BC.4070506@redhat.com> (Cong Wang's message of "Fri\, 05 Feb 2010 17\:37\:00 +0800")
Message-ID: <m11vh0dmur.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cong Wang <amwang@redhat.com> writes:

> Eric W. Biederman wrote:
>> Amerigo Wang <amwang@redhat.com> writes:
>>
>>> Recently we met a lockdep warning from sysfs during s2ram or cpu hotplug.
>>> As reported by several people, it is something like:
>>
>> The interesting case is the cpu hotplug is actually a problem.  It isn't
>> useful to get a complaint about the non-problems code paths triggered
>> by pm.  However my earlier review spotted a real deadlock case.  Where
>> in one of the sysfs attributes we iterate over the list of online cpus
>> and that appeared to an attribute that removing a cpu would remove
>> from sysfs...
>>
>
> You are referring this one:
> http://marc.info/?l=linux-kernel&m=126474021428905&w=2
> ?
>
> Hmm, yeah, I missed that the lock it is holding is not s_active, thus so
> not be the case we are trying to fix here.

Right that error appears to be legitimate.  I think that is actually a
different cpu hotplug problem then the one I spotted by audit.
Spotting weird problems like that are why it is worth it for me to go
to the problem to add lockdep annotations to sysfs, and why it is
worth debugging them.

Hopefully I will have enough energy in the next little while to help
cut down on the false positive rate.

Eric
