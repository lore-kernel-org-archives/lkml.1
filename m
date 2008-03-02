Return-Path: <linux-kernel-owner+w=401wt.eu-S1756901AbYCBAth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbYCBAth (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 19:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbYCBAt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 19:49:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33721 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbYCBAt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 19:49:27 -0500
Date: Sat, 1 Mar 2008 19:49:20 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cleanup: correct tabbing of check_kill_permission()
Message-ID: <20080302004920.GA31969@infradead.org>
References: <47C9D986.3040805@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C9D986.3040805@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2008 at 02:32:38PM -0800, Andrew G. Morgan wrote:
> +	if (info == SEND_SIG_NOINFO
> +	    || (!is_si_special(info) && SI_FROMUSER(info))) {
> +		 /* Let audit system see the signal */
> +		error = audit_signal_info(sig, t);
>  		if (error)
>  			return error;
>  		error = -EPERM;
> -		if (((sig != SIGCONT) ||
> -			(task_session_nr(current) != task_session_nr(t)))
> +		if (((sig != SIGCONT)
> +		     || (task_session_nr(current) != task_session_nr(t)))
>  		    && (current->euid ^ t->suid) && (current->euid ^ t->uid)
>  		    && (current->uid ^ t->suid) && (current->uid ^ t->uid)
>  		    && !capable(CAP_KILL))
> -		return error;
> +			return error;

If you start reformmating it please get it completely right:

	if (info == SEND_SIG_NOINFO ||
	    (!is_si_special(info) && SI_FROMUSER(info))) {
		/* Let audit system see the signal */
		error = audit_signal_info(sig, t);
 		if (error)
 			return error;
 		error = -EPERM;
		if ((sig != SIGCONT ||
		     (task_session_nr(current) != task_session_nr(t))) &&
		    (current->euid ^ t->suid) && (current->euid ^ t->uid) &&
		    (current->uid ^ t->suid) && (current->uid ^ t->uid) &&
		    !capable(CAP_KILL))
			return error;
 	}
