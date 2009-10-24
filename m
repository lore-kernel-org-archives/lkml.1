Return-Path: <linux-kernel-owner+w=401wt.eu-S1752264AbZJXDhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbZJXDhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 23:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbZJXDhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 23:37:19 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:43629 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbZJXDhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 23:37:18 -0400
Date: Fri, 23 Oct 2009 20:38:39 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Matt Helsley <matthltc@us.ibm.com>, Oren Laadan <orenl@librato.com>,
       Daniel Lezcano <daniel.lezcano@free.fr>, randy.dunlap@oracle.com,
       arnd@arndb.de, linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Louis.Rilling@kerlabs.com, kosaki.motohiro@jp.fujitsu.com,
       hpa@zytor.com, mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
Message-ID: <20091024033839.GA16430@us.ibm.com>
References: <m1r5sxsw7w.fsf@fess.ebiederm.org> <20091021062021.GA2667@us.ibm.com> <m1eioxrtsb.fsf@fess.ebiederm.org> <20091023004253.GA7915@us.ibm.com> <m1bpjyrkep.fsf@fess.ebiederm.org> <20091023053001.GA24972@us.ibm.com> <m1ws2mpsuk.fsf@fess.ebiederm.org> <20091023192124.GA11088@us.ibm.com> <20091023204812.GA26524@us.ibm.com> <m1y6n1lmk7.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1y6n1lmk7.fsf@fess.ebiederm.org>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman [ebiederm@xmission.com] wrote:
| > +static int set_pidmap(struct pid_namespace *pid_ns, int target)
| > +{
| > +	if (!target)
| > +		return alloc_pidmap(pid_ns);

BTW,  we need this now that the RESERVED_PIDS check is is conditional on
->last_pid. But this makes set_pidmap() completely general so should we
have alloc_pid() call set_pidmap() always ? Or we could move this check
into alloc_pid(), but it may be better to have all values of 'target'
checked in one place.

| > +
| > +	if (target >= pid_max)
| > +		return -EINVAL;
| > +
| > +	if ((target < 0) || (target < RESERVED_PIDS && pid_ns == &init_pid_ns))
| > +		return -EINVAL;
| 
| if ((target < 0) || ((target < RESERVED_PIDS) && (pid_ns->last_pid >= RESERVED_PIDS)))
| 
| Please.

Ok.
