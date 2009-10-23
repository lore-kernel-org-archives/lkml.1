Return-Path: <linux-kernel-owner+w=401wt.eu-S1751597AbZJWAld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbZJWAld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 20:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbZJWAlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 20:41:32 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54979 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbZJWAlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 20:41:31 -0400
Date: Thu, 22 Oct 2009 17:42:53 -0700
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
Message-ID: <20091023004253.GA7915@us.ibm.com>
References: <4ADCCD68.9030003@free.fr> <4ADCDE7F.4090501@librato.com> <20091020005125.GG27627@count0.beaverton.ibm.com> <m1vdiad9jd.fsf@fess.ebiederm.org> <20091020040315.GA26632@us.ibm.com> <m1iqeauyvl.fsf@fess.ebiederm.org> <20091020183329.GB22646@us.ibm.com> <m1r5sxsw7w.fsf@fess.ebiederm.org> <20091021062021.GA2667@us.ibm.com> <m1eioxrtsb.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1eioxrtsb.fsf@fess.ebiederm.org>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman [ebiederm@xmission.com] wrote:
| +static int set_pidmap(struct pid_namespace *pid_ns, int target)
| +{
| +	if (target >= pid_max)
| +		return -1;

I am changing this and the next return to 'return -EINVAL', to match
an earlier patch in my patchset.

| +	if (target < RESERVED_PIDS)

Should we replace RESERVED_PIDS with 0 ? We currently allow new
containers to have pids 1..32K in the first pass and in subsequent
passes assign starting at RESERVED_PIDS.

Sukadev
