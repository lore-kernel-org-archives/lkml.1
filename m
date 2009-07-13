Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbZGMRGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbZGMRGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 13:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755698AbZGMRGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 13:06:33 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:38678 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597AbZGMRGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 13:06:32 -0400
To: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       kexec-ml <kexec@lists.infradead.org>,
       lkml <linux-kernel@vger.kernel.org>, Simon Horman <horms@verge.net.au>
References: <4A55A4AE.3000206@mxs.nes.nec.co.jp>
	<4A56E069.5040907@jp.fujitsu.com> <4A5AB903.6090204@mxs.nes.nec.co.jp>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 13 Jul 2009 10:06:25 -0700
In-Reply-To: <4A5AB903.6090204@mxs.nes.nec.co.jp> (Ken'ichi Ohmichi's message of "Mon\, 13 Jul 2009 13\:33\:07 +0900")
Message-ID: <m14otga4xa.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, seto.hidetoshi@jp.fujitsu.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH-v2] kdump: Enable kdump if 2nd-kernel is loaded.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp> writes:

> Hi,
>
> This patch is a new version by Seto-san's comment.
>
>
> Changelog since v1:
> * Remove the check code other than kexec_crash_image from kexec_should_crash()
>   because a kexec cannot crash if there is no image.
>
>
> This patch enables a kdump if 2nd-kernel is loaded.
> (The patch is based on linux-2.6.31-rc2.)
>
> Now, a kdump on oops is enabled if a kernel parameter "oops=panic"
> is specified and 2nd-kernel is loaded. I think that a kdump should
> be enabled regardless of "oops=panic" if 2nd-kernel is loaded,
> because a system administrator loads 2nd-kernel for enabling a kdump.

The Documentation for sysrq-c certainly needs to be updated.

If I am doing development on a system I like oops's.  All of the
information and nothing goes down.  I can get at /proc/kcore etc.

In a setting where I can't be Johnny on the spot and look at
things a core dump is probably the best I can get.  In that scenario
panic_on_oops sounds good.

As I read the current check it reads:
If we are going to panic and not oops || panic_on_oops
	kexec_should_crash = true;

Which seems a very reasonable implementation of policy.

Eric
