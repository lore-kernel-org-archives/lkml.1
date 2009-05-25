Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbZEYHxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbZEYHxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 03:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbZEYHxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 03:53:25 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:36553 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbZEYHxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 03:53:23 -0400
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       stern <stern@rowland.harvard.edu>
References: <m1bppofm9k.fsf@fess.ebiederm.org>
	<1243109591-21611-5-git-send-email-ebiederm@xmission.com>
	<ac3eb2510905231427x62efaecfod2b11472fcdbcc21@mail.gmail.com>
	<1243169978.3502.7.camel@poy> <m1bppid1pw.fsf@fess.ebiederm.org>
	<1243178448.4035.12.camel@poy> <m1iqjpaap1.fsf@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 25 May 2009 00:53:21 -0700
In-Reply-To: <m1iqjpaap1.fsf@fess.ebiederm.org> (Eric W. Biederman's message of "Mon\, 25 May 2009 00\:44\:26 -0700")
Message-ID: <m13aataaa6.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: kay.sievers@vrfy.org, stern@rowland.harvard.edu, ebiederm@aristanetworks.com, linux-fsdevel@vger.kernel.org, cornelia.huck@de.ibm.com, tj@kernel.org, linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kay Sievers <kay.sievers@vrfy.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4487]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs  directories.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

> Kay Sievers <kay.sievers@vrfy.org> writes:
>
>>> Let's make the plan to investigate these, and see how hard it would be
>>> to actually remove these with the current device/sysfs infrastructure.
>>> 
>>> Fixing the users and adding back auto-deletion are the only two real options.
>>
>> Seems, we should remove non-directory files, which in most cases belong
>> to the kobject itself, but the user's cleanup logic does not cover the
>> removal of the created files.
>>
>> But I think, we should still warn, if we find a sub-directory inside a
>> directory we are going to remove.
>
> So far complaining about deleting non-empty directories is finding
> real bugs.  It does not appear that too many users that delete
> non-empty directories.
>
> My plan moving forward is to see what has goofed and how hard it is to
> change the callers to clean up after themselves.  If it is not a pain
> to fix the callers who forget to delete their attributes that looks
> like the right way forward.
>
> It is certainly the principle of least surprise.

Currently I expect that those attributes that are not deleted may
actually be bugs as well.  If a driver manually adds sysfs files after
device_create/device_register the uevent will have already been sent
and you can not safely use those attributes in when processing a hotplug
event.

Eric
