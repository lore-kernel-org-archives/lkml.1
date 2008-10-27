Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbYJ0UZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbYJ0UZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 16:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbYJ0UZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 16:25:07 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:60563 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbYJ0UZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 16:25:05 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: benjamin.thery@bull.net, serue@us.ibm.com, netdev@vger.kernel.org,
       gregkh@suse.de, viro@ftp.linux.org.uk, dlezcano@fr.ibm.com,
       linux-kernel@vger.kernel.org, htejun@gmail.com, den@openvz.org,
       containers@lists.linux-foundation.org
References: <20081022212124.GA9910@us.ibm.com> <49003019.40904@bull.net>
	<m1fxmni9uv.fsf_-_@frodo.ebiederm.org>
	<20081027.124126.74749150.davem@davemloft.net>
Date: Mon, 27 Oct 2008 13:19:27 -0700
In-Reply-To: <20081027.124126.74749150.davem@davemloft.net> (David Miller's
	message of "Mon, 27 Oct 2008 12:41:26 -0700 (PDT)")
Message-ID: <m1skqh4wq8.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;David Miller <davem@davemloft.net>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.2 SARE_LWSHORTT BODY: SARE_LWSHORTT
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1242]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] netns: Coexist with the sysfs limitations v2
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: ebiederm@xmission.com (Eric W. Biederman)
> Date: Thu, 23 Oct 2008 08:56:08 -0700
>
>> To make testing of the network namespace simpler allow
>> the network namespace code and the sysfs code to be
>> compiled and run at the same time.  To do this only
>> virtual devices are allowed in the additional network
>> namespaces and those virtual devices are not placed
>> in the kobject tree.
>> 
>> Since virtual devices don't actually do anything interesting
>> hardware wise that needs device management there should
>> be no loss in keeping them out of the kobject tree and
>> by implication sysfs.  The gain in ease of testing
>> and code coverage should be significant.
>> 
>> Changelog:
>> 
>> v2: As pointed out by Benjamin Thery it only makes sense to call
>>     device_rename in the initial network namespace for now.
>> 
>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>> Acked-by: Benjamin Thery <benjamin.thery@bull.net>
>> Tested-by: Serge Hallyn <serue@us.ibm.com>
>> Acked-by: Serge Hallyn <serue@us.ibm.com>
>> Acked-by: Daniel Lezcano <dlezcano@fr.ibm.com>
>
> So let's figure out what happens with this patch.
> I'm personally ok with the change, the question is when
> and where.
>
> My net-2.6 tree was closed to new features long ago, so I really
> don't want to try to merge this sucker into 2.6.28-rcX :-)  But if
> you guys think that is prudent, feel free to submit it directly to
> Linus and add my signoff:
>
> Signed-off-by: David S. Miller <davem@davemloft.net>
>
> otherwise if we shoot for 2.6.29 I would suggest that we wait until
> the merge window to see if the sysfs issues get sorted, and if not
> we slip this patch into to tree instead.
>
> Let me know what you guys plan to do with this.

What I was thinking is that it goes into your tree for 2.6.29.  Allowing
for better test coverage in the short term, and removing the pressure
to do a hack job on sysfs just to reduce the pain of testing.

The patch was sent during the merge window just because that is
when the conversation was happening.

I guess the pain with sysfs is having multiple patches in different
trees in this area causing conflicts in linux-next.  Ugh.  I can see
why you would want to hold back.  On the contrary point of view we
need that patch in someones tree or else we might as well merge it
now, if the plan is to merge it without it sitting in anyone's
development tree.

So my plan is I'm not going to worry about that patch, and leave it to
Ben and Daniel (if it needs a retransmit).  If it happens to merge
into net-next and that causes conflicts when we do a good job on
sysfs I will handle it.

Eric
