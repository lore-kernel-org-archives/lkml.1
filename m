Return-Path: <linux-kernel-owner+w=401wt.eu-S933486AbZKXQhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933486AbZKXQhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 11:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932214AbZKXQhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 11:37:12 -0500
Received: from imap.ru.mvista.com ([213.79.90.228]:3968 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758123AbZKXQhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 11:37:11 -0500
Date: Tue, 24 Nov 2009 18:41:45 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@kernel.crashing.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 7/8] spi_mpc8xxx: Turn qe_mode into flags
Message-ID: <20091124154145.GA23040@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20091012164841.GA32214@oksana.dev.rtsoft.ru>
 <20091012164925.GG4578@oksana.dev.rtsoft.ru>
 <3E303C4F-CE29-470F-B34A-3413F31BC23C@kernel.crashing.org>
 <1259039016.16367.118.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1259039016.16367.118.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 04:03:36PM +1100, Benjamin Herrenschmidt wrote:
[...]
> This patch breaks my 6xx config:
> 
> /home/benh/linux-powerpc-test/arch/powerpc/platforms/83xx/mpc832x_rdb.c: In function ‘of_fsl_spi_probe’:
> /home/benh/linux-powerpc-test/arch/powerpc/platforms/83xx/mpc832x_rdb.c:77: error: ‘struct fsl_spi_platform_data’ has no member named ‘qe_
> 
> The reason is that the mpc832x_rdb.c code still uses the legacy probing
> method. The fix is not totally trivial as the new flags are defined inside
> spi_mpc8xxx.c

Thanks for noticing. I indeed forgot about the legacy stuff. :-/

> If you are going to keep the flags in the .c file you probably also want
> to remove the platform device definition from fsl_devices.h anyways as
> there's no point exposing to the world a structure with a "flags" member
> if the definition of those flags isn't also exposed.

Yep. Though, IIRC Joakim asked to keep the legacy bindings for some
time (until we implement SPI chip-select framework?)... so for now
we'll have to leave we the exposed flags.

Thanks again,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
