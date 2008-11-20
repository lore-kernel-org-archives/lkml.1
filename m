Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbYKTB0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbYKTB0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 20:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbYKTBZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 20:25:56 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:35208 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbYKTBZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 20:25:54 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-man@vger.kernel.org, Kirill Korotaev <dev@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Andrey Savochkin <saw@sw.ru>,
       Subrata Modak <subrata@linux.vnet.ibm.com>
References: <492464F8.8070101@gmail.com>
Date: Wed, 19 Nov 2008 17:21:56 -0800
In-Reply-To: <492464F8.8070101@gmail.com> (Michael Kerrisk's message of "Wed,
	19 Nov 2008 14:11:52 -0500")
Message-ID: <m1y6zfgpjf.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Michael Kerrisk <mtk.manpages@googlemail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4319]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: CLONE_NEWUTS documentation
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk <mtk.manpages@googlemail.com> writes:

> Serge, Eric,
>
> Below is a patch to document the CLONE_NEWUTS flag that was
> added in 2.6.19.
>
> Could you please review and let me know of improvements
> or inaccuracies?
>
> By the way, does anyone know where the UTS name in the uname()
> API comes from? My best guess is that it's from Unix Timesharing
> System, but I don't know this for sure.
>
> Cheers,
>
> Michael
>
> diff --git a/man2/clone.2 b/man2/clone.2
> index 7212332..80f9caf 100644
> --- a/man2/clone.2
> +++ b/man2/clone.2
> @@ -341,6 +340,33 @@ configuration option and that the process be privileged
>  This flag can't be specified in conjunction with
>  .BR CLONE_THREAD .
>  .TP
> +.BR CLONE_NEWUTS " (since Linux 2.6.19)"
> +If
> +.B CLONE_NEWUTS
> +is set, then create the process in a new UTS namespace.
> +If this flag is not set, then (as with
> +.BR fork (2)),
> +the process is created in the same UTS namespace as
> +the calling process.

> +This flag is intended for the implementation of control groups.

See my previous email about containers vs control groups.

There are some corner cases with NFS usage in the kernel that still
need to be resolved but otherwise the uts namespace is considered correct
and complete.

Eric
