Return-Path: <linux-kernel-owner+w=401wt.eu-S1760138AbYHHTTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760138AbYHHTTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 15:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754410AbYHHTTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 15:19:40 -0400
Received: from dresden.studentenwerk.mhn.de ([141.84.225.229]:39682 "EHLO
	email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750695AbYHHTTj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 15:19:39 -0400
From: Wolfgang Walter <wolfgang.walter@stwm.de>
Organization: Studentenwerk =?iso-8859-1?q?M=FCnchen?=
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Kernel oops with 2.6.26, padlock and ipsec: probably problem with fpu state changes
Date: Fri, 8 Aug 2008 21:19:37 +0200
User-Agent: KMail/1.9.5
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, viro@zeniv.linux.org.uk,
       vegard.nossum@gmail.com
References: <200807171653.59177.wolfgang.walter@stwm.de> <20080808185356.GC607@linux-os.sc.intel.com> <489C97FB.2030408@zytor.com>
In-Reply-To: <489C97FB.2030408@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808082119.37778.wolfgang.walter@stwm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 8. August 2008 21:01 schrieb H. Peter Anvin:
> Suresh Siddha wrote:
> > I propose to go with wolf's patch which add's kernel_fpu_begin() and
> > kernel_fpu_end() around these instructions. This is the correct fix
> > (unless there is something wrong in my above understanding).
>
> It's technically overkill, if (and only if!) these instructions don't
> actually touch the SSE state (most likely they're using the SSE
> pipeline, and need this stuff to deal with power management issues.)
>
> However, overkill is a good way to make sure something is dead.
> Applying the patch will make sure we fix the regression, and we can
> worry about optimizing this further post-2.6.27.
>
> 	-hpa

Probably

drivers/crypto/padlock-sha.c
drivers/char/hw_random/via-rng.c

needs a fix, too.

Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
Leiter EDV
Leopoldstraße 15
80802 München
Tel: +49 89 38196 276
Fax: +49 89 38196 150
Email: wolfgang.walter@stwm.de
http://www.studentenwerk-muenchen.de/
