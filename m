Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbYIKKpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbYIKKpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 06:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbYIKKpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 06:45:05 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:34000 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbYIKKpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 06:45:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: serue@us.ibm.com, akpm@linux-foundation.org, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <E1KYNMl-0000TG-Qs@pomaz-ex.szeredi.hu>
	<20080827184600.GA8069@us.ibm.com>
	<E1KaxLm-0006OD-K8@pomaz-ex.szeredi.hu>
	<20080903220215.GA27705@us.ibm.com>
	<E1Kb0ml-0006qL-5M@pomaz-ex.szeredi.hu>
	<20080903224334.GA726@us.ibm.com>
	<E1Kb8Y0-0008Gh-FP@pomaz-ex.szeredi.hu>
	<20080904132804.GA14709@us.ibm.com>
	<E1KbFU3-0002Ne-Oe@pomaz-ex.szeredi.hu>
	<E1KbGwb-0002rl-49@pomaz-ex.szeredi.hu>
	<20080905153134.GA18367@us.ibm.com>
	<E1Kd3Mh-0001vk-F5@pomaz-ex.szeredi.hu>
Date: Thu, 11 Sep 2008 03:37:45 -0700
In-Reply-To: <E1Kd3Mh-0001vk-F5@pomaz-ex.szeredi.hu> (Miklos Szeredi's message
	of "Tue, 09 Sep 2008 15:34:43 +0200")
Message-ID: <m11vzrge86.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Miklos Szeredi <miklos@szeredi.hu>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0008]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: unprivileged mounts git tree
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> On Fri, 5 Sep 2008, Serge E. Hallyn wrote:
>> Ok I should take the time to properly add these to ltp, but for now here
>> is the result of 15-minutes of playing around with shell scripts to do
>> some basic testing.
>> 
>> Run usermounts_root.sh as root first, then usermounts_user as a user.
>> Cleanup for the usermounts_root.sh side-effects is not done.
>> 
>> Miklos, do you have better-thought-out or more complete testcases?
>
> Thanks for the scripts, I don't have any better ones, I have only been
> testing by hand.
>
> As for -mm, sure it would be nice.  I'll do a resubmission of the
> whole series with proper changelog, etc.  It would be really nice if
> Al and/or Christoph could review if there are any major conceptual
> problems left.

There is a weird corner case I'm trying to wrap my head around.
unlink and rmdir do not work on dentries that are mount points
in another mount namespace.

Which is at least needed for the moment so we don't leak mounts.

Once we have unprivileged mounts does that introduce a DOS attack?

Eric
