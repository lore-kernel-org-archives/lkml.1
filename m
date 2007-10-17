Return-Path: <linux-kernel-owner+w=401wt.eu-S1764108AbXJQORy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764108AbXJQORy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 10:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbXJQORr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 10:17:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:51668 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754423AbXJQORq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 10:17:46 -0400
From: Andreas Schwab <schwab@suse.de>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] fix not-and/or errors
References: <47161243.6060007@tiscali.nl>
X-Yow: I predict that by 1993 everyone will live in and around LAS VEGAS and
 wear BEATLE HAIRCUTS!
Date: Wed, 17 Oct 2007 16:17:44 +0200
In-Reply-To: <47161243.6060007@tiscali.nl> (Roel Kluin's message of "Wed\, 17
	Oct 2007 15\:46\:43 +0200")
Message-ID: <jemyuhj053.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin <12o3l@tiscali.nl> writes:

> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 73c44cb..81943ef 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -2882,7 +2882,7 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
>  			    !(STp->use_pf & PF_TESTED)) {
>  				/* Try the other possible state of Page Format if not
>  				   already tried */
> -				STp->use_pf = !STp->use_pf | PF_TESTED;
> +				STp->use_pf = !(STp->use_pf | PF_TESTED);

This does not make sense.  Since PF_TESTED is non-zero the expression
will always be zero.

Looking at the context the original expression is likely to be the
intended one.  use_pf at this point can either be 0 or 1 (USE_PF), and
the result is supposed to be (1|PF_TESTED) or (0|PF_TESTED), resp.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
