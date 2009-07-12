Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbZGLO6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbZGLO6R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 10:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbZGLO6C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 10:58:02 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53135 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959AbZGLO6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 10:58:00 -0400
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Parag Warudkar <parag.warudkar@gmail.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, Al Viro <viro@ZenIV.linux.org.uk>
References: <20090708101734.27241.88930.stgit@pc1117.cambridge.arm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 12 Jul 2009 07:57:51 -0700
In-Reply-To: <20090708101734.27241.88930.stgit@pc1117.cambridge.arm.com> (Catalin Marinas's message of "Wed\, 08 Jul 2009 11\:17\:34 +0100")
Message-ID: <m1ljmune34.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: catalin.marinas@arm.com, viro@ZenIV.linux.org.uk, gregkh@suse.de, linux-kernel@vger.kernel.org, parag.warudkar@gmail.com, akpm@linux-foundation.org, torvalds@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Catalin Marinas <catalin.marinas@arm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] Free the memory allocated by memdup_user() in fs/sysfs/bin.c
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas <catalin.marinas@arm.com> writes:

> Commit 1c8542c7bb replaced kmalloc() with memdup_user() in the write()
> function but also dropped the kfree(temp). The memdup_user() function
> allocates memory which is never freed.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Parag Warudkar <parag.warudkar@gmail.com>
> ---
>  fs/sysfs/bin.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
> index 9345806..2524714 100644
> --- a/fs/sysfs/bin.c
> +++ b/fs/sysfs/bin.c
> @@ -171,6 +171,7 @@ static ssize_t write(struct file *file, const char __user *userbuf,
>  	if (count > 0)
>  		*off = offs + count;
>  
> +	kfree(temp);
>  	return count;
>  }
>  
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
