Return-Path: <linux-kernel-owner+w=401wt.eu-S1758605AbZEEIih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605AbZEEIih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 04:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757744AbZEEIiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 04:38:23 -0400
Received: from aun.it.uu.se ([130.238.12.36]:51030 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758520AbZEEIiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 04:38:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18943.64242.208899.90833@pilspetsen.it.uu.se>
Date: Tue, 5 May 2009 10:38:10 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: scsi <linux-scsi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: drivers/scsi/st.c:2967: warning: suggest parentheses around operand 
	of '!' or change '|' to '||' or '!' to '~'
In-Reply-To: <10f740e80905050051q37524c4dv5d33b501b704b3b0@mail.gmail.com>
References: <10f740e80905050051q37524c4dv5d33b501b704b3b0@mail.gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven writes:
 > drivers/scsi/st.c:2967: warning: suggest parentheses around operand of
 > '!' or change '|' to '||' or '!' to '~'
 > 
 >         if (cmdstatp->sense_hdr.sense_key == ILLEGAL_REQUEST &&
 >             !(STp->use_pf & PF_TESTED)) {
 >                 /* Try the other possible state of Page Format if not
 >                    already tried */
 >                 STp->use_pf = !STp->use_pf | PF_TESTED;
 >                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 >                 st_release_request(SRpnt);
 >                 SRpnt = NULL;
 >                 return st_int_ioctl(STp, cmd_in, arg);
 >         }
 > 
 > Looks indeed incorrect to me...

I noticed that too yesterday. I believe the intention is

	STp->use_pf = (!STp->use_pf) | PF_TESTED;

which in this case (PF_TESTED is clear) is the same as

	STp->use_pf = (STp->use_pf ^ USE_PF) | PF_TESTED;

which matches the comment, or

	STp->use_pf ^= (USE_PF | PF_TESTED);

if you want to micro-optimize.
