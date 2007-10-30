Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbXJ3Vwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbXJ3Vwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 17:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbXJ3Vwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 17:52:33 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:56830 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbXJ3Vwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 17:52:33 -0400
Date: Tue, 30 Oct 2007 22:54:09 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Alex Riesen <raa.lkml@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Per Liden <per.liden@ericsson.com>,
       Allan Stephens <allan.stephens@windriver.com>
Cc: David Miller <davem@davemloft.net>
Subject: Re: tipc_config.h requires linux/string.h, which does not exist in exported headers
Message-ID: <20071030215409.GB19598@uranus.ravnborg.org>
References: <20071030191317.GB9403@steel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030191317.GB9403@steel.home>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 08:13:17PM +0100, Alex Riesen wrote:
> Sorry for random Cc: list.
> 
> v2.6.24-rc1-423-g97855b4, with CONFIG_HEADERS_CHECK=y
> 
> $ make
> ...
>   CHECK   include/linux/tipc_config.h
> /home/raa/linux/usr/include/linux/tipc_config.h requires linux/string.h, which does not exist in exported headers
> make[3]: *** [/home/raa/linux/usr/include/linux/.check.tipc_config.h] Error 1
> make[2]: *** [linux] Error 2
> make[1]: *** [headers_check] Error 2
> make: *** [vmlinux] Error 2

tipc_config.h uses memcpy in an inline function that is
never used in the kernel.
I'm awaiting response from tipc people if we can kill
that inline or we should make it a macro.
But davem decided just to include tipc_config.h and will now
sort it out.

	Sam
