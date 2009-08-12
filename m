Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432AbZHLBv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbZHLBv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 21:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755098AbZHLBv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 21:51:56 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:52082 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbZHLBvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 21:51:55 -0400
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       Neil Horman <nhorman@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>
References: <20090811104144.5154.77871.sendpatchset@localhost.localdomain>
	<m163cub067.fsf@fess.ebiederm.org> <4A82182C.1080501@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 11 Aug 2009 18:51:52 -0700
In-Reply-To: <4A82182C.1080501@redhat.com> (Amerigo Wang's message of "Wed\, 12 Aug 2009 09\:17\:32 +0800")
Message-ID: <m1eirhlryf.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: amwang@redhat.com, mingo@elte.hu, akpm@linux-foundation.org, andi@firstfloor.org, nhorman@redhat.com, linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Amerigo Wang <amwang@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [RFC Patch 1/2] kexec: show memory info in /proc/iomem
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang <amwang@redhat.com> writes:

>> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>>
>> We can inspect the image we are going to load to get this information.
>> In fact /sbin/kexec already inspects the image we are going to load
>> to get this information.  Putting this in the kernel adds kernel
>> complexity for no gain.
>>   
>
> /sbin/kexec is supported to know this, of course. But this is not for
> /sbin/kexec, this is for user (or other programs) to observe the memory
> information, so that he can know the memory he reserved is too much or not.

> Without this, it is a little hard to use patch 2/2.

So add on option to /sbin/kexec.

Furthermore none of this does a good job of predicting how much
memory /sbin/fsck will require to check the filesystem before we
write a crash dump.

The only way I know of reliably obtaining that kind of information is
testing your crash userspace with different amounts of memory and
understanding what is going on.

Eric
