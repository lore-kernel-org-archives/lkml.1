Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbYCaSia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbYCaSia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 14:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbYCaSiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 14:38:23 -0400
Received: from smtp10.unit.tiscali.de ([213.205.33.46]:46889 "EHLO
	smtp10.unit.tiscali.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbYCaSiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 14:38:23 -0400
Message-ID: <47F12CE9.1090202@the2masters.de>
Date: Mon, 31 Mar 2008 20:26:49 +0200
From: Stefan Hellermann <stefan@the2masters.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20080218)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: make O=dir fails with current git
References: <47EE8829.10409@the2masters.de> <20080331180022.GA4833@uranus.ravnborg.org>
In-Reply-To: <20080331180022.GA4833@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg schrieb:
> On Sat, Mar 29, 2008 at 07:19:21PM +0100, Stefan Hellermann wrote:
>> Hi,
>>
>> I'm using "make O=machinename" for building different kernels from one tree. About 15 days
>> ago it was okay, with current git it fails:
>> $ make O=client1
>> scripts/kconfig/conf -s arch/x86/Kconfig
>>   Using /srv/devel/kernel as source for kernel
>>   /srv/devel/kernel is not clean, please run 'make mrproper'
>>   in the '/srv/devel/kernel' directory.
>> make[1]: *** [prepare3] Error 1
>> make: *** [sub-make] Error 2
>>
>> running "make mrproper" (without O=dir) doesn't help.
>> I've not changed anything, I only made a "git-pull".
>> Now I'm at home, tried "mkdir test; make O=test defconfig all" with current git-head, it
>> doesn't work too.
> 
> I tried to reproduce this here without luck.
> The tests performed by kbuild to dertermine if the
> source directory is clean are very basic.
> If the file .config exist or the directory
> include/config exists then the source tree is considered clean.
> Otherwise you get the above message.

Hi, damn, it's that easy!
It was the .config file, I added (as root) a symlink to dir/.config to let some other
application check if some Kernel-options are set, then the permissions of this symlink
prevented make mrproper from removing it.

For what purpose is this check? I can't point the other application to kerneldir/dir
because it also greps in kerneldir/Makefile for the kernel-version.

Thanks
Stefan

> 
> Can you please try to run: make mrproper
> and then manually check if the .config file
> or the include/config directory exists.
> 
> If they exists after make mrproper then
> check your permissions.
> 
> In any case let me know the result.
> 
> 	Sam
