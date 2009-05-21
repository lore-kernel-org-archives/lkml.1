Return-Path: <linux-kernel-owner+w=401wt.eu-S1753194AbZEUGN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbZEUGN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 02:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbZEUGNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 02:13:08 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58070 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbZEUGNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 02:13:06 -0400
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
References: <m1bppofm9k.fsf@fess.ebiederm.org>
	<1242865694-2100-1-git-send-email-ebiederm@xmission.com>
	<1242865694-2100-2-git-send-email-ebiederm@xmission.com>
	<1242865694-2100-3-git-send-email-ebiederm@xmission.com>
	<4A14E89E.7010600@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 20 May 2009 23:12:59 -0700
In-Reply-To: <4A14E89E.7010600@kernel.org> (Tejun Heo's message of "Thu\, 21 May 2009 14\:37\:34 +0900")
Message-ID: <m1iqjv9e6s.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: tj@kernel.org, ebiederm@aristanetworks.com, linux-fsdevel@vger.kernel.org, cornelia.huck@de.ibm.com, linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 03/20] sysfs: Remove now unnecessary error reporting suppression.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Eric W. Biederman wrote:
>> From: Eric W. Biederman <ebiederm@xmission.com>
>> 
>> Now that we use sysfs_rename_link in the places we previously
>> used sysfs_create_link_nowarn we can remove sysfs_create_link_nowarn
>> and all it's supporting infrastructure.
>
> I'm not entirely sure why implementing a rename helper means that we
> don't need nowarn version anymore.  Nothing really changed or is it
> that the nowarn version wasn't too necessary anyway?

nowarn was used exclusively in the hand coded version of rename.  By
switching the order I was able perform the operations such that even
if the operation is ultimately a noop and are attempt to recreate the
same link we won't have problems.

The two callers of device_rename are required (and do) perform locking
to ensure the rename operation is safe.  So the exact implementation
in the sysfs does not matter.  Although making it atomic would be
ideal.

The nowarn helpers existed because the order was backwards in
device rename and when a noop rename happened sysfs would mistakenly
think there was a problem and complain.  I think the upper
layers suppress that case now for a while at least it lead to
a lot of spurious warnings.

Eric
