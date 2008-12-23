Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861AbYLWAhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbYLWAhm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 19:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbYLWAhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 19:37:15 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:54609 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbYLWAhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 19:37:12 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, ebiederm@xmission.com,
       roland@redhat.com, bastian@waldi.eu.org, daniel@hozac.com,
       xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, sukadev@us.ibm.com
Subject: Re: [RFC][PATCH 4/6][v3] Define siginfo_from_ancestor_ns()
References: <20081221005106.GA4912@us.ibm.com>
	<20081221005424.GD5025@us.ibm.com> <20081222222604.GA1536@redhat.com>
	<20081222230133.GD1536@redhat.com> <20081222235837.GC13079@us.ibm.com>
	<20081223002215.GA7984@redhat.com>
Date: Mon, 22 Dec 2008 16:32:16 -0800
In-Reply-To: <20081223002215.GA7984@redhat.com> (Oleg Nesterov's message of
	"Tue, 23 Dec 2008 01:22:15 +0100")
Message-ID: <m13agf68a7.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: No (on mx04.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

>> I was going through the ->si_pid assignments to try and fix them at
>> source (like the mqueue patch I sent last week).
>
> OK.

Note.  When a signal goes to a process group (or similar) we can't fix
si_pid at the source.  We have to fix it when only a single destination
process is known.  It doesn't mean that fixing it at the source
is hopeless but...  

>> The two cases that don't fit the model are sys_kill() and sys_tkill().
>> For that I was hoping we could use siginfo_from_user() again. i.e
>>
>> 	if (siginfo_from_user())
>> 		masquerade_si_pid()
>>
>> in the default: case of send_signal(). To be safe, masquerade_si_pid()
>> could do it only iff si_code is either SI_USER or SI_TKILL.
>>
>> IOW, with some tweaks, I am trying to see if we can use siginfo_from_user()
>> in place of the SIG_FROM_USER.
>
> sys_rt_sigqueueinfo().
>
> But, perhaps we can just ignore the problems with sigqueueinfo() (and
> document them). 

Yes.  I don't think si_pid is valid in that case anyway.  It is the
kernel signals where si_pid is a reliable field that are important.

Eric
