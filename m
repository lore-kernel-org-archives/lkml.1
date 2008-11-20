Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbYKTB0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbYKTB0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 20:26:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbYKTBZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 20:25:54 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:45697 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbYKTBZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 20:25:52 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Kirill Korotaev <dev@openvz.org>, Pavel Emelianov <xemul@openvz.org>,
       Cedric Le Goater <clg@fr.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-man@vger.kernel.org
References: <4924651C.4080909@gmail.com>
Date: Wed, 19 Nov 2008 17:16:28 -0800
In-Reply-To: <4924651C.4080909@gmail.com> (Michael Kerrisk's message of "Wed,
	19 Nov 2008 14:12:28 -0500")
Message-ID: <m163mji4cz.fsf@frodo.ebiederm.org>
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
	*      [score: 0.4844]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: CLONE_NEWIPC documentation
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk <mtk.manpages@googlemail.com> writes:

> Kirill, Pavel,
>
> Below is a patch to document the CLONE_NEWIPC flag that was
> added in 2.6.19.
>
> Could you please review and let me know of improvements
> or inaccuracies?
>
> Cheers,
>
> Michael
>
> --- a/man2/clone.2
> +++ b/man2/clone.2
> @@ -225,6 +224,36 @@ Calls to
>  .BR umask (2)
>  performed later by one of the processes do not affect the other process.
>  .TP
> +.BR CLONE_NEWIPC " (since Linux 2.4.19)"
> +If
> +.B CLONE_NEWIPC
> +is set, then create the process in a new IPC namespace.
> +If this flag is not set, then (as with
> +.BR fork (2)),
> +the process is created in the same IPC namespace as
> +the calling process.

> +This flag is intended for the implementation of control groups.

The above sentence is wrong.

+This flag is intended for the implementation of containers.

Would be correct.

Both control groups and namespaces feed into the user space container
concept.  Control groups are multiprocess resource limits.
Namespaces are affect the mapping from resource name to resource.

What is interesting is you can unshare a sysvipc namespace and still have
sysvipc shared memory mapped from another sysvipc namespace.

This is something that needs to be watched for.

Eric
