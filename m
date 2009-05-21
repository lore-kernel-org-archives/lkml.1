Return-Path: <linux-kernel-owner+w=401wt.eu-S1753194AbZEUJSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbZEUJSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 05:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbZEUJSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 05:18:47 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:56380 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbZEUJSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 05:18:46 -0400
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
References: <m1bppofm9k.fsf@fess.ebiederm.org>
	<1242865694-2100-1-git-send-email-ebiederm@xmission.com>
	<1242865694-2100-2-git-send-email-ebiederm@xmission.com>
	<1242865694-2100-3-git-send-email-ebiederm@xmission.com>
	<1242865694-2100-4-git-send-email-ebiederm@xmission.com>
	<4A14F356.3030501@kernel.org> <m1k54a7w2x.fsf@fess.ebiederm.org>
	<4A15046A.10106@kernel.org> <m1octm287f.fsf@fess.ebiederm.org>
	<4A1512E2.2040505@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 21 May 2009 02:18:40 -0700
In-Reply-To: <4A1512E2.2040505@kernel.org> (Tejun Heo's message of "Thu\, 21 May 2009 17\:37\:54 +0900")
Message-ID: <m1vdnuyftb.fsf@fess.ebiederm.org>
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
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.3964]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 04/20] sysfs: Handle the general case of removing of directories with subdirectories
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Well, it can be trivially fixed by checking the removed flag.  The
> add/rm thing is designed to help additions and removals of multiple
> nodes at one go and I'd really like to see it working that way.  Any
> chance you can change code toward that direction?

Yes.  We definitely need to check the removed flag in sysfs_add_one.
Regardless of anything else.

I need to sleep on this but I am inclined to get rid of the rest of
the complications simply by failing the removal of non-empty
directories.  Going through the upper layers and making them properly
responsible for their actions.

I am afraid friendlier in this circumstance might equate to easier
to misuse and let code bugs pile up.

Eric
