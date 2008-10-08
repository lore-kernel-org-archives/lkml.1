Return-Path: <linux-kernel-owner+w=401wt.eu-S1757683AbYJHBGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683AbYJHBGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 21:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755238AbYJHBGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 21:06:04 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:48783 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbYJHBGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 21:06:02 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <tj@kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Benjamin Thery <benjamin.thery@bull.net>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serue@us.ibm.com>,
       Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <48D7AC44.6050208@bull.net> <20080922153455.GA6238@kroah.com>
	<48D8FC1E.6000601@bull.net> <m1k5d2oh4y.fsf@frodo.ebiederm.org>
	<20081003101331.GH28946@ZenIV.linux.org.uk>
	<48EB27FE.2090009@kernel.org> <m1zllgzki0.fsf@frodo.ebiederm.org>
	<48EB53B8.5020309@kernel.org> <48EBEE0B.6080009@kernel.org>
	<m1k5cklzpc.fsf@frodo.ebiederm.org> <48EBFCD3.4050809@kernel.org>
Date: Tue, 07 Oct 2008 17:58:34 -0700
In-Reply-To: <48EBFCD3.4050809@kernel.org> (Tejun Heo's message of "Wed, 08
	Oct 2008 09:20:35 +0900")
Message-ID: <m1skr7hphh.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.3131]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: sysfs: tagged directories not merged completely yet
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hmmm... I'm probably missing something (and being lazy) but how does it
> guarantee the validity of the next pointer after dropping the rcu lock?

So in next_tid which is essentially what we would be doing.
I grab the rcu_lock.  Check something to see if the task I have
is still on the list, if it is then I know the next is valid until
the end of the rcu grace period.  Then I follow the next pointer,
and grab the lock again.

rcu is pain to get right but at least it is localized pain.

>> I'm still not certain how we can get the lock ordering so it doesn't
>> cause us problems.  I will look at revalidation and what the other
>> distributed filesystems are doing and see if that might work.  If it
>> doesn't we need refactor the VFS locking.
>
> Yeah, if we can make sysfs behave like other distributed filesystems, it
> would be great.  :-)

I don't think we can make it work but I think we need to exhaust that
avenue before saying that the VFS has to change.

Eric
