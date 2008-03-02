Return-Path: <linux-kernel-owner+w=401wt.eu-S1752856AbYCBFPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbYCBFPy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 00:15:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbYCBFPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 00:15:45 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:42377 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbYCBFPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 00:15:45 -0500
Message-ID: <47CA37E7.2030404@kernel.org>
Date: Sat, 01 Mar 2008 21:15:19 -0800
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cleanup: correct tabbing of check_kill_permission()
References: <47C9D986.3040805@kernel.org> <20080302004920.GA31969@infradead.org>
In-Reply-To: <20080302004920.GA31969@infradead.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Christoph,

I ran it through scripts/checkpatch.pl - it said it was ok - and I see
that other places in this file contain code of this style -
do_sigaltstack() for example.

Could you give me a reference for "completely right"? Its not obvious to
me that Documentation/CodingStyle is what you are using as a reference.

Thanks

Andrew

Christoph Hellwig wrote:
| On Sat, Mar 01, 2008 at 02:32:38PM -0800, Andrew G. Morgan wrote:
|> +	if (info == SEND_SIG_NOINFO
|> +	    || (!is_si_special(info) && SI_FROMUSER(info))) {
|> +		 /* Let audit system see the signal */
|> +		error = audit_signal_info(sig, t);
|>  		if (error)
|>  			return error;
|>  		error = -EPERM;
|> -		if (((sig != SIGCONT) ||
|> -			(task_session_nr(current) != task_session_nr(t)))
|> +		if (((sig != SIGCONT)
|> +		     || (task_session_nr(current) != task_session_nr(t)))
|>  		    && (current->euid ^ t->suid) && (current->euid ^ t->uid)
|>  		    && (current->uid ^ t->suid) && (current->uid ^ t->uid)
|>  		    && !capable(CAP_KILL))
|> -		return error;
|> +			return error;
|
| If you start reformmating it please get it completely right:
|
| 	if (info == SEND_SIG_NOINFO ||
| 	    (!is_si_special(info) && SI_FROMUSER(info))) {
| 		/* Let audit system see the signal */
| 		error = audit_signal_info(sig, t);
|  		if (error)
|  			return error;
|  		error = -EPERM;
| 		if ((sig != SIGCONT ||
| 		     (task_session_nr(current) != task_session_nr(t))) &&
| 		    (current->euid ^ t->suid) && (current->euid ^ t->uid) &&
| 		    (current->uid ^ t->suid) && (current->uid ^ t->uid) &&
| 		    !capable(CAP_KILL))
| 			return error;
|  	}
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFHyjfn+bHCR3gb8jsRAuilAJ9QJKsEQz66UrFtLOCcHVokGcVV7wCeP0HE
ftOI2APLX1YpWiznyhLfN6U=
=HGa0
-----END PGP SIGNATURE-----
