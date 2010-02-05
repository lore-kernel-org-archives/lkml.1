Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab0BEJBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 04:01:53 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:41855 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab0BEJBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 04:01:52 -0500
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>, akpm@linux-foundation.org
Subject: Re: [Patch v2] sysfs: add lockdep class support to s_active
References: <20100205064622.4141.72867.sendpatchset@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 05 Feb 2010 01:01:47 -0800
In-Reply-To: <20100205064622.4141.72867.sendpatchset@localhost.localdomain> (Amerigo Wang's message of "Fri\, 5 Feb 2010 01\:42\:56 -0500")
Message-ID: <m1iqachx8k.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang <amwang@redhat.com> writes:

> Recently we met a lockdep warning from sysfs during s2ram or cpu hotplug.
> As reported by several people, it is something like:

The interesting case is the cpu hotplug is actually a problem.  It isn't
useful to get a complaint about the non-problems code paths triggered
by pm.  However my earlier review spotted a real deadlock case.  Where
in one of the sysfs attributes we iterate over the list of online cpus
and that appeared to an attribute that removing a cpu would remove
from sysfs...

Eric
