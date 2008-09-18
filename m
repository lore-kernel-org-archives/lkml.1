Return-Path: <linux-kernel-owner+w=401wt.eu-S1757083AbYIRP0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083AbYIRP0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 11:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756698AbYIRP0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 11:26:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33601 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756661AbYIRP0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 11:26:21 -0400
Date: Thu, 18 Sep 2008 12:25:41 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: diet-kconfig: a script to trim unneeded kconfigs
Message-ID: <20080918122541.2c3c7b39@areia.chehab.org>
In-Reply-To: <s5hbpyny7bl.wl%tiwai@suse.de>
References: <s5hbpyny7bl.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

On Wed, 17 Sep 2008 01:55:26 +0200
Takashi Iwai <tiwai@suse.de> wrote:

> Hi,
> 
> a topic that just came up in kernel summit is a script to remove
> unneeded kernel configs automatically to reduce the compile time.
> Incidentally, I already wrote such a script during the last SUSE hack
> week a couple of weeks ago, so I'd like to share here, hopefully to
> give an idea for further improvements.
> 
> The script checks the currently loaded modules and trims other
> CONFIG_XXX=m simply, and tries make oldconfig, and writes out the
> resultant .config in the current directory after some checks. 
> You can specify the config file via option,  as default, it reads from
> /proc/config.gz. 

I agree with Giacomo: you should also check for /boot/config-`uname -r`
and /boot/config-`uname -r`.gz.

Also, if the idea is to make life easier for kernel newbies, I think the better
would be to have the script called at kernel Makefile (something like "make
diet"), and having a few other config's available somewhere at kernel tree,
since even a "minimal" kernel may need (or not) a few random modules, like
usb-storage. So, I think we should open a dialog that allows the selection of
using the previous kernel config or selecting between a few profiles like
"minimalist" (just the auto-detected things), "desktop" (adding things like
usb-storage), "notebook" (with a power-saving optimized config),
"server" (adding stuff like LVM, RAID5 and some advanced network configs).

It seems a good idea to check at /proc/cpuinfo and optimize for that
specific processor, enabling SMP only if needed, and only for the number of
existing cores.

> The script is VERY hackish.  I should have begun with perl or whatever
> better script language, but I chose bash and co.  So, don't expect
> much code quality.  I'm no script guy after all :)

Using just a shellscript and binutils seems to be better than using other
tools, since it allows the usage on minimal configured systems where the user
might not have perl or other scripting languages.

Cheers,
Mauro.
