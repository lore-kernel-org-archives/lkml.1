Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbYICOet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbYICOet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 10:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbYICOem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 10:34:42 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:50048 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbYICOel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 10:34:41 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <tj@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, serue@us.ibm.com, greg@kroah.com,
       fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <1219945263-21074-1-git-send-email-tj@kernel.org>
	<1219945263-21074-6-git-send-email-tj@kernel.org>
	<20080828175116.GB18461@kroah.com> <48B6E79E.6020702@kernel.org>
	<48B6E801.9080102@kernel.org> <E1KYm0D-0003q0-IQ@pomaz-ex.szeredi.hu>
	<48B6EBBD.6050406@kernel.org> <E1KYm9u-0003v5-4t@pomaz-ex.szeredi.hu>
	<48B6EF98.4070008@kernel.org> <E1KYn7T-00048J-Qj@pomaz-ex.szeredi.hu>
	<48B6FFB6.7000104@kernel.org> <E1KYnhA-0004Ei-3t@pomaz-ex.szeredi.hu>
	<48B75C94.7030604@kernel.org> <E1KYyt9-0005Ur-Eu@pomaz-ex.szeredi.hu>
	<48B7AF60.8040709@kernel.org> <E1KYzMd-0005aR-28@pomaz-ex.szeredi.hu>
	<48B7BB4C.4060907@kernel.org> <m163pjr5qf.fsf@frodo.ebiederm.org>
	<E1Ka82g-0003NU-4D@pomaz-ex.szeredi.hu> <48BBD9F5.8060906@kernel.org>
Date: Wed, 03 Sep 2008 07:32:22 -0700
In-Reply-To: <48BBD9F5.8060906@kernel.org> (Tejun Heo's message of "Mon, 01
	Sep 2008 14:03:01 +0200")
Message-ID: <m163pdb8qx.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.0962]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello,
>
> Miklos Szeredi wrote:
>>> So why not just only support well defined ioctls and serialize them
>>> in the kernel and allow the receiving process to deserialize them?
>> 
>> I'd like the idea of limiting to well behaved ioctls, but Tejun
>> doesn't...
>
> I'm not dead against it.  I'm just a bit more inclined to my
> implementation (naturally), which means if you're dead against the
> current implementation, supporting only the proper ones definitely is
> an option, but comparing the pros and cons, I'm not quite convinced
> yet.

I really think that if an ioctl is passing through the kernel we
should know how to parse and understand it's options.  Otherwise
we won't have the option of doing backwards compatibility when something
changes, like we can with the 32->64bit ioctls.

That seems to imply that you need a stub in the kernel to handle 
really weird ioctls.

The upside is that because you know what the inputs and outputs are
and where the inputs and output are you can support that ioctl well
into the future, and you can do it with an unprivileged file
system server.

Eric
