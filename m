Return-Path: <linux-kernel-owner+w=401wt.eu-S1753530AbYKGP4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbYKGP4F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 10:56:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbYKGPzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 10:55:54 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:48510 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbYKGPzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 10:55:53 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com, viro@ZenIV.linux.org.uk,
       containers@lists.osdl.org
References: <m1ej1p2l6u.fsf@frodo.ebiederm.org>
	<m1abcd2kqk.fsf@frodo.ebiederm.org>
	<20081106172617.dd51d0af.akpm@linux-foundation.org>
	<m1abccxpc5.fsf@frodo.ebiederm.org>
	<20081106184945.179c248a.akpm@linux-foundation.org>
	<m1iqr0urb8.fsf@frodo.ebiederm.org>
	<20081106202822.a1af8a6e.akpm@linux-foundation.org>
Date: Fri, 07 Nov 2008 07:51:32 -0800
In-Reply-To: <20081106202822.a1af8a6e.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 6 Nov 2008 20:28:22 -0800")
Message-ID: <m1d4h7v8jf.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, containers@lists.osdl.org, viro@ZenIV.linux.org.uk, adobriyan@gmail.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 2/7] proc: Implement support for automounts in task directories
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu, 06 Nov 2008 19:51:23 -0800 ebiederm@xmission.com (Eric W. Biederman)
> wrote:
>
>> If we could do all of this with reference counting so that the
>> mount would persist exactly until the last user of it has gone
>> away without a periodic poll I would love it.  But the infrastructure
>> doesn't support that today,
>
> Well that sucks.  The free-on-last-put idiom occurs in so many places
> and serves us so well.  I wonder what went wrong here?

> I guess it has interactions with dentry and inode cache aging which
> could get tricky.

At least in part.  If you just have the dentry you can't  easily
find what is mounted on it.  

>> and where this is at least partially
>> a bug fix I would rather not have the change depend on enhancing
>> the VFS.
>> 
>> The algorithm is actually very aggressive and in practice you don't
>> see any /proc/<pid>/net showing up as a mount point.
>
> Do you think it has failure modes?  Most particularly: obscure usage
> patterns which can cause memory exhaustion?

I don't think we can pin anything that way that we can't
pin right now.

You might be able to pin more if you happen to mount something
on top of /proc/<pid>/net/  but that is an unprivileged operation.

>> > Obviously, that becomes clearer as one spends more time with the code,
>> > but I wonder whether this has all been made as maintainble as it
>> > possibly could be.
>> 
>> Good question.
>> 
>> In the sense of will we have to go through and futz with the code all
>> of the time.  The abstraction seems good.   You put a mount on
>> the proc_automounts list with do_add_mounts and it goes away eventually
>> with all of the vfs rules maintained.
>> 
>> In the sense of can the code be read?    Perhaps it could be better.
>> I expect it helps to have run the code and see /proc/net as a filesystem.
>> that is magically mounted.
>
> 'twould be a useful contribution if you were to enshrine your
> discoveries in /*these things*/.  You knew I was working up to that :)

Short of a big fat comment I'm not certain if there is something I can do
better.

Eric

