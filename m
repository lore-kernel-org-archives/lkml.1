Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab0CKDwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 22:52:36 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:44845 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab0CKDwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 22:52:34 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: Upstream first policy
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org>
	<20100308094647.GA14268@elte.hu>
	<20100308173008.7ae389ab@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.1003080948060.3989@localhost.localdomain>
	<20100308190857.400bde09@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.1003081115280.3989@localhost.localdomain>
	<m1fx4apgch.fsf@fess.ebiederm.org>
	<20100309224941.79511705@lxorguk.ukuu.org.uk>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 10 Mar 2010 19:52:26 -0800
In-Reply-To: <20100309224941.79511705@lxorguk.ukuu.org.uk> (Alan Cox's message of "Tue\, 9 Mar 2010 22\:49\:41 +0000")
Message-ID: <m1d3zbecqt.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: alan@lxorguk.ukuu.org.uk, viro@ftp.linux.org.uk, kyle@mcmartin.ca, linux-kernel@vger.kernel.org, jmorris@namei.org, mingo@elte.hu, torvalds@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Weird.  Somehow I only got a copy of this from lkml.

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> time.  If pathnames were not fundamentally important we could apply
>> a patch like the one below and allow unprivileged users to unshare
>> the mount namespace and mount filesystems wherever.  There is nothing
>> fundamental about those operations that require root privileges except
>> that you are manipulating the pathnames of objects.
>
> And in a purely SELinux enviromnment your patch would work out because
> you could use labels to control this stuff.
>  
>
>> -	if (!capable(CAP_SYS_ADMIN))
>> -		return -EPERM;
>> -
>
> It does raise the question about whether you can do it if you had a
> namespace property of "ignore suidness". I'm not sure thats enough
> however.

The long term plan is to change that to.

	if (nscapable(mnt_ns->user_ns, CAP_SYS_ADMIN))
		return -EPERM.

That is.
- Create a new user/credential namespace (ultimately an unprivileged operation).
- Have the root user of the new user namespace create a new mount namespace.
- Over that new mount namespace the root user of the new user namespace
  has full control.

It is a little convoluted but it maintains backwards compatibility.  Unfortunately
there is still a long ways to go before we get there.

Eric
