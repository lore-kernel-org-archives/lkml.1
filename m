Return-Path: <linux-kernel-owner+w=401wt.eu-S1753862AbYA0Fb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbYA0Fb4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 00:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbYA0Fbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 00:31:47 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37712 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbYA0Fbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 00:31:46 -0500
Date: Sat, 26 Jan 2008 21:36:06 -0800
From: Greg KH <greg@kroah.com>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       sfr@canb.auug.org.au
Subject: Re: [PATCH] Fix powerpc vio_find_name to not use devices_subsys
Message-ID: <20080127053606.GA24306@kroah.com>
References: <18331.54314.379281.960297@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18331.54314.379281.960297@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2008 at 11:45:30AM +1100, Paul Mackerras wrote:
> This fixes vio_find_name() in arch/powerpc/kernel/vio.c, which is
> currently broken because it tries to use devices_subsys.  That is bad
> for two reasons: (1) it's doing (or trying to do) a scan of all
> devices when it should only be scanning those on the vio bus, and
> (2) devices_subsys was an internal symbol of the device system code
> which was never meant for external use and has now gone away, and
> thus the kernel fails to compile on pSeries.
> 
> The new version uses bus_find_device() on the vio bus (vio_bus_type).
> 
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> ---
> Greg, do you want to send this to Linus or will I do that?  Or do you
> have a better version? :)

I'll send it to him, with a minor change (I'm going to make this a core
function, as others also use the same functionality, no need for
everyone to re-invent the wheel all the time.

I also have some other patches to send him to fix up the fall-out of
these driver core changes :)

thanks,

greg k-h
