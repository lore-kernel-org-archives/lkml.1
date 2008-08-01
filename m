Return-Path: <linux-kernel-owner+w=401wt.eu-S1758415AbYHASe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758415AbYHASe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 14:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758606AbYHASdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 14:33:04 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35374 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757789AbYHASdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 14:33:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Robin Holt <holt@sgi.com>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Paul Menage <menage@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080731170022.GE9663@sgi.com>
	<m1prot297c.fsf@frodo.ebiederm.org> <20080731193204.GG9663@sgi.com>
	<m1iqul25rk.fsf@frodo.ebiederm.org> <20080731200835.GK9663@sgi.com>
	<m1bq0d1zhz.fsf@frodo.ebiederm.org> <20080801120455.GP9663@sgi.com>
Date: Fri, 01 Aug 2008 11:27:20 -0700
In-Reply-To: <20080801120455.GP9663@sgi.com> (Robin Holt's message of "Fri, 1
	Aug 2008 07:04:55 -0500")
Message-ID: <m1proszj3r.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Robin Holt <holt@sgi.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0301]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [Patch] Scale pidhash_shift/pidhash_size up based on num_possible_cpus().
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Holt <holt@sgi.com> writes:

> On Thu, Jul 31, 2008 at 03:04:56PM -0700, Eric W. Biederman wrote:
>> Robin Holt <holt@sgi.com> writes:
>> 
>> > Like so???
>> >
>> > I have not tested this yet.
>> 
>> Looks reasonable to me.
>> 
>> In what circumstances was the lookup in the pid hash table with
>> long changes causing a performance slowdown?.  We don't perform
>> a lot of lookups.
>
> It was initially detected while profiling 'ps' on a 2048p machine that
> had 13 kernel threads per cpu.  We added a couple more device drivers
> which added additional threads.  We then started a pthread-on-process
> MPI job which had 2048 ranks each with 4 threads (test-case from
> customer job).  There were misc other processes out there which brought
> our task count up to approx 63k.  Larger page size helped the problem
> (went from 16k to 64k).

Large page size?  Do you mean larger hash size?

What were you measuring that showed improvement with the large hash size?

Eric
