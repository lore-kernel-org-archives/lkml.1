Return-Path: <linux-kernel-owner+w=401wt.eu-S1756998AbZDGHS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998AbZDGHS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 03:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbZDGHSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 03:18:16 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:40068 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbZDGHSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 03:18:15 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <200904060450.n364oaUj031923@imap1.linux-foundation.org>
	<20090406210921.9efab09b.randy.dunlap@oracle.com>
	<49DAD2AA.9000604@oracle.com>
	<20090406212539.13d28f16.akpm@linux-foundation.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 07 Apr 2009 00:18:07 -0700
In-Reply-To: <20090406212539.13d28f16.akpm@linux-foundation.org> (Andrew Morton's message of "Mon\, 6 Apr 2009 21\:25\:39 -0700")
Message-ID: <m1d4bpszio.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: mmotm 2009-04-05-21-45 uploaded (sysctl)
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Mon, 06 Apr 2009 21:12:26 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
>
>> Randy Dunlap wrote:
>> > On Sun, 05 Apr 2009 21:50:36 -0700 akpm@linux-foundation.org wrote:
>> > 
>> >> The mm-of-the-moment snapshot 2009-04-05-21-45 has been uploaded to
>> >>
>> >>    http://userweb.kernel.org/~akpm/mmotm/
>> >>
>> >> and will soon be available at
>> >>
>> >>    git://git.zen-sources.org/zen/mmotm.git
>> >>
>> >> It contains the following patches against 2.6.29:
>> > 
>> > 
>> > kernel/sysctl.c: In function '__register_sysctl_paths':
>> > kernel/sysctl.c:2059: error: 'struct ctl_table_header' has no member named 'dep_map'
>> > 
>> > 
>> > config attached.
>> > 
>> > ---
>> > ~Randy
>> 
>> kernel/sysctl.c: s/CONFIG_DEBUG_LOCK_ALLOC/CONFIG_PROVE_LOCKING/ at line 2056.
>
> OK, thanks, sysctl-lockdep-support-for-sysctl-reference-counting.patch.
>
> I have a note here that Peter had issues with that patch anyway.  I'm
> not yet sure if it's due to be fixed or dropped or what?

Let's call it due to be fixed.

Right now I see this going one of two ways.
1) I get the locking model fixed as requested.
2) I move the whole use counting/locking up to the struct file level,
   solve this generically for sysfs, sysctl, proc, uio and whatever
   other subsystem needs this logic.

I should know by the end of the week if I can do this generically.

If I can not do this generically it make sense to fix the patch,
and I will.  It is on my todo list.

If I can do this generically it makes sense to drop the patch,
and completely rewrite all of that code, and make certain lockdep
works on my reimplementation.

Eric
