Return-Path: <linux-kernel-owner+w=401wt.eu-S1751684AbZJWBDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbZJWBDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 21:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbZJWBDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 21:03:52 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:34642 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbZJWBDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 21:03:51 -0400
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
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
References: <4ADCCD68.9030003@free.fr> <4ADCDE7F.4090501@librato.com>
	<20091020005125.GG27627@count0.beaverton.ibm.com>
	<m1vdiad9jd.fsf@fess.ebiederm.org> <20091020040315.GA26632@us.ibm.com>
	<m1iqeauyvl.fsf@fess.ebiederm.org> <20091020183329.GB22646@us.ibm.com>
	<m1r5sxsw7w.fsf@fess.ebiederm.org> <20091021062021.GA2667@us.ibm.com>
	<m1eioxrtsb.fsf@fess.ebiederm.org> <20091023004253.GA7915@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 22 Oct 2009 18:03:42 -0700
In-Reply-To: <20091023004253.GA7915@us.ibm.com> (Sukadev Bhattiprolu's message of "Thu\, 22 Oct 2009 17\:42\:53 -0700")
Message-ID: <m1bpjyrkep.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com> writes:

> Eric W. Biederman [ebiederm@xmission.com] wrote:
> | +static int set_pidmap(struct pid_namespace *pid_ns, int target)
> | +{
> | +	if (target >= pid_max)
> | +		return -1;
>
> I am changing this and the next return to 'return -EINVAL', to match
> an earlier patch in my patchset.
>
> | +	if (target < RESERVED_PIDS)
>
> Should we replace RESERVED_PIDS with 0 ? We currently allow new
> containers to have pids 1..32K in the first pass and in subsequent
> passes assign starting at RESERVED_PIDS.

If it is a preexisting namespace pid namespace removing the RESERVED_PIDS
check removes most if not all of the point of RESERVED_PIDS.

In a new fresh pid namespace I have no problem with not performing
the RESERVED_PIDS check.

So I guess that makes the check.

if ((target < RESERVED_PIDS) && pid_ns->last_pid >= RESERVED_PIDS)
   return -EINVAL;

Eric
