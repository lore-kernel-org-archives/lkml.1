Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbYCaSAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbYCaSAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 14:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbYCaR76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 13:59:58 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:41629 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbYCaR76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 13:59:58 -0400
Date: Mon, 31 Mar 2008 20:00:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Stefan Hellermann <stefan@the2masters.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: make O=dir fails with current git
Message-ID: <20080331180022.GA4833@uranus.ravnborg.org>
References: <47EE8829.10409@the2masters.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47EE8829.10409@the2masters.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 29, 2008 at 07:19:21PM +0100, Stefan Hellermann wrote:
> Hi,
> 
> I'm using "make O=machinename" for building different kernels from one tree. About 15 days
> ago it was okay, with current git it fails:
> $ make O=client1
> scripts/kconfig/conf -s arch/x86/Kconfig
>   Using /srv/devel/kernel as source for kernel
>   /srv/devel/kernel is not clean, please run 'make mrproper'
>   in the '/srv/devel/kernel' directory.
> make[1]: *** [prepare3] Error 1
> make: *** [sub-make] Error 2
> 
> running "make mrproper" (without O=dir) doesn't help.
> I've not changed anything, I only made a "git-pull".
> Now I'm at home, tried "mkdir test; make O=test defconfig all" with current git-head, it
> doesn't work too.

I tried to reproduce this here without luck.
The tests performed by kbuild to dertermine if the
source directory is clean are very basic.
If the file .config exist or the directory
include/config exists then the source tree is considered clean.
Otherwise you get the above message.

Can you please try to run: make mrproper
and then manually check if the .config file
or the include/config directory exists.

If they exists after make mrproper then
check your permissions.

In any case let me know the result.

	Sam
