Return-Path: <linux-kernel-owner+w=401wt.eu-S1758741AbYG2NH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbYG2NH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 09:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbYG2NHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 09:07:48 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:39161 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbYG2NHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 09:07:47 -0400
Date: Tue, 29 Jul 2008 23:07:45 +1000
From: Simon Horman <horms@verge.net.au>
To: Keith Owens <kaos@ocs.com.au>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tony Luck <tony.luck@intel.com>
Subject: Re: [patch] IA64: only call up() in salinfo_work_to_do() if
	down_trylock() was successful
Message-ID: <20080729130742.GA20158@verge.net.au>
References: <20080729094718.GA5247@verge.net.au> <1163.1217335629@ocs10w>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1163.1217335629@ocs10w>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 10:47:09PM +1000, Keith Owens wrote:
> Simon Horman (on Tue, 29 Jul 2008 19:47:20 +1000) wrote:
> >Aesthetic issues aside is it safe to call up() if down_trylock() failed?
> >
> >arch/ia64/kernel/salinfo.c: In function `salinfo_work_to_do':
> >arch/ia64/kernel/salinfo.c:195: warning: ignoring return value of `down_trylock'
> >
> >Signed-off-by: Simon Horman <horms@verge.net.au>
> >
> >Index: linux-2.6/arch/ia64/kernel/salinfo.c
> >===================================================================
> >--- linux-2.6.orig/arch/ia64/kernel/salinfo.c	2008-07-29 19:06:33.000000000 +1000
> >+++ linux-2.6/arch/ia64/kernel/salinfo.c	2008-07-29 19:40:02.000000000 +1000
> >@@ -192,8 +192,8 @@ struct salinfo_platform_oemdata_parms {
> > static void
> > salinfo_work_to_do(struct salinfo_data *data)
> > {
> >-	down_trylock(&data->mutex);
> >-	up(&data->mutex);
> >+	if (down_trylock(&data->mutex) == 0)
> >+		up(&data->mutex);
> > }
> > 
> > static void
> 
> NAK.  The whole point of this function is to set the mutex to the up
> state, irrespective of whether it was already down or not.  Tracking
> the state of data->mutex in all the possible contexts is just too
> fragile, especially since it can be modified from NMI context.
> salinfo_work_to_do() ensures that the mtuex ends in the up state.
> 
> To remove the warning, just stick '(void)' in front of down_trylock().

Thanks, will do.

-- 
Horms

