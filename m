Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbZAaDyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbZAaDyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbZAaDyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 22:54:01 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:58288 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbZAaDyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 22:54:00 -0500
To: Tim Small <tim@buttersideup.com>
Cc: Doug Thompson <norsk5@yahoo.com>, ncunningham-lkml@crca.org.au,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Chris Friesen <cfriesen@nortel.com>, Pavel Machek <pavel@suse.cz>,
       bluesmoke-devel@lists.sourceforge.net,
       Arjan van de Ven <arjan@infradead.org>
References: <715599.77204.qm@web50111.mail.re2.yahoo.com>
	<m1wscc7fop.fsf@fess.ebiederm.org> <49836114.1090209@buttersideup.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 30 Jan 2009 19:54:05 -0800
In-Reply-To: <49836114.1090209@buttersideup.com> (Tim Small's message of "Fri\, 30 Jan 2009 20\:20\:36 +0000")
Message-ID: <m1iqnw1676.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: tim@buttersideup.com, arjan@infradead.org, bluesmoke-devel@lists.sourceforge.net, pavel@suse.cz, cfriesen@nortel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, ncunningham-lkml@crca.org.au, norsk5@yahoo.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tim Small <tim@buttersideup.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: marching through all physical memory in software
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Small <tim@buttersideup.com> writes:

> Eric W. Biederman wrote:
>> A background software scrubber simply has the job of rewritting memory
>> to it's current content so that the data and the ecc check bits are
>> guaranteed to be in sync
>
> Don't you just need to READ memory?  The memory controller hardware takes care
> of the rest in the vast majority of cases.
>
> You only need to rewrite RAM if a correctable error occurs, and the chipset
> doesn't support automatic write-back of the corrected value (a different problem
> altogether...).  The actual memory bits themselves are refreshed by the hardware
> quite frequently (max of every 64ms for DDR2, I believe)...

At the point we are talking about software scrubbing it makes sense to assume
a least common denominator memory controller, one that does not do automatic
write-back of the corrected value, as all of the recent memory controllers
do scrubbing in hardware.

Once you handle the stupidest hardware all other cases are just software optimizations
on that, and we already have the tricky code that does a read-modify-write without
changing the contents of memory, so guarantees everything it touches will be written
back.

Eric
