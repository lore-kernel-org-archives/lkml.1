Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbYJQP2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbYJQP2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbYJQP2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:28:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3115 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970AbYJQP2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:28:41 -0400
Date: Fri, 17 Oct 2008 16:28:36 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Takashi Iwai <tiwai@suse.de>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, alsa-devel@alsa-project.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       lrg@slimlogic.co.uk
Subject: Re: [alsa-devel] [PATCH] Fix debugfs_create_dir's error checking	method for sound/soc/
Message-ID: <20081017152833.GI2546@sirena.org.uk>
References: <48F88D77.2080106@cn.fujitsu.com> <20081017132340.GF2546@sirena.org.uk> <s5hfxmvw8lq.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hfxmvw8lq.wl%tiwai@suse.de>
X-Cookie: Monitor not included.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 05:21:21PM +0200, Takashi Iwai wrote:

> This looks like a design.  In linux/debugfs.h:

Yeah, so my grovelling through the code after I wrote that e-mail
showed.

> /* 
>  * We do not return NULL from these functions if CONFIG_DEBUG_FS is not enabled
>  * so users have a chance to detect if there was a real error or not.  We don't
>  * want to duplicate the design decision mistakes of procfs and devfs again.
>  */

> Though, I agree that the detailed error information is lost by
> returning NULL...

Yes, not to mention the fact that using both error reporting interfaces
makes writing client code more error prone.  Looking at the users most
seem to only check one kind of error code is returned.  

For ASoC checking only for null would actually be good enough - even if
-ENODEV is returned we only ever pass the pointers into other debugfs
functions so the fact that the pointer is bogus makes no odds, it'll
never actually be dereferenced.
