Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbZEUK3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbZEUK3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 06:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbZEUK3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 06:29:30 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48533 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbZEUK32 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 06:29:28 -0400
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Benjamin Thery <benjamin.thery@bull.net>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
References: <m1bppofm9k.fsf@fess.ebiederm.org>
	<1242865694-2100-1-git-send-email-ebiederm@xmission.com>
	<4A14E836.5090302@kernel.org>
	<ac3eb2510905210306o48bdf4c8rf7459b35aa521998@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 21 May 2009 03:29:20 -0700
In-Reply-To: <ac3eb2510905210306o48bdf4c8rf7459b35aa521998@mail.gmail.com> (Kay Sievers's message of "Thu\, 21 May 2009 12\:06\:18 +0200")
Message-ID: <m1zld6u4u7.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: kay.sievers@vrfy.org, ebiederm@aristanetworks.com, dlezcano@fr.ibm.com, benjamin.thery@bull.net, linux-fsdevel@vger.kernel.org, cornelia.huck@de.ibm.com, linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org, tj@kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kay Sievers <kay.sievers@vrfy.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4899]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 01/20] sysfs: Implement sysfs_rename_link
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay.sievers@vrfy.org> writes:

> On Thu, May 21, 2009 at 07:35, Tejun Heo <tj@kernel.org> wrote:
>> Eric W. Biederman wrote:
>>> +int sysfs_rename_link(struct kobject *kobj, struct kobject *targ,
>>> +                     const char *old, const char *new)
>>> +{
>>> +     sysfs_remove_link(kobj, old);
>>> +     return sysfs_create_link(kobj, targ, new);
>>> +}
>>> +
>>
>> Removal and creation are done in the reverse order compared to the one
>> used in device rename.  The important difference is that previously
>> failed operation was noop whereas it now would remove the current
>> link.  I think the old order is correct.
>
> The target string is composed on-demand, and it always points to the
> same kobject and *targ is not needed, right?
>
> Can't we just change the name of the link, instead of removing and
> re-creating the entire thing, and all these issues go away?

Good point.  It looks like I can generalize sysfs_mv_dir into simply
being sysfs_rename.  All of the existing logic looks like it can handle
that.  I will look at doing an incremental patch for that.

Eric
