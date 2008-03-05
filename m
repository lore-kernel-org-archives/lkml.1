Return-Path: <linux-kernel-owner+w=401wt.eu-S932642AbYCEXEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642AbYCEXEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765006AbYCEW7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:59:17 -0500
Received: from gra-lx1.iram.es ([150.214.224.41]:35956 "EHLO gra-lx1.iram.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932451AbYCEW7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:59:14 -0500
From: Gabriel Paubert <paubert@iram.es>
Date: Wed, 5 Mar 2008 23:59:02 +0100
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Jarod Wilson <jwilson@redhat.com>, benh@kernel.crashing.org,
       Kristian Hoegsberg <krh@bitplanet.net>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net, Sam Ravnborg <sam@ravnborg.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 1/2] firewire: endianess fix
Message-ID: <20080305225902.GA27985@iram.es>
References: <20080220220326.GA22328@uranus.ravnborg.org> <200802272221.38985.jwilson@redhat.com> <1204179959.15052.372.camel@pasglop> <200802281342.06493.jwilson@redhat.com> <1204241162.15052.393.camel@pasglop> <47C79CB1.6050104@redhat.com> <20080303091927.GA27105@iram.es> <47CC0C95.1030709@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CC0C95.1030709@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 03:35:01PM +0100, Stefan Richter wrote:
> Gabriel Paubert wrote:
> > I have a Pismo which I use on a virtually
> > daily basis (and about to remove the last remnants of MacOS on it). 
> > However I have disabled Firewire because it would not sleep and wake 
> > up properly. 
> > 
> > I can test it on Wednesday with a 5GB fireflly disk from 2001.
> > 
> > Please tell me which configuration options I need to set for
> > Firewire (which stack, etc...).
> 
> Config options of the new stack:
> FIREWIRE=m
> FIREWIRE_OHCI=m
> FIREWIRE_SBP2=m
> 
> Config options of the old stack:
> IEEE1394=m
> IEEE1394_OHCI1394=m
> IEEE1394_SBP2=m
> and if desired also the other drivers for raw userspace access,
> isochronous I/O (alias video1394 even though it can also be used for
> other purposes), DV I/O, and IPv4 over 1394.
> 
> The two SBP2 drivers also need SCSI and BLK_DEV_SD a.k.a. SCSI disk
> support or/and BLK_DEV_SR a.k.a. SCSI CDROM support.
> 
> You can also set the options to Y but I find loadable and hence
> unloadable modules more practical... 'cause I unload and reload them all
> the time.  :-)

Indeed, although this machine typically had non-modular kernels, I
compiled one for these tests.

For now I have only tested the new stack with a 6 year old 1.8" disk
and everything works, including suspend to RAM. The kernel is 2.6.25-rc4
plus additional pull from linux1394-2.6.git: 2.6.25-rc4-00032-g8d36ba4.

Thanks a lot.

	Regards,
	Gabriel

P.S: it seems that something broke in the APM emulation around rc2
on this machine, battery level reads at -1% from /proc/apm.
> Caveats:
>   - You could build and install both stacks but should then blacklist
>     at least one of ohci1394 or firewire-ohci.  Better keep it simple
>     and install only one of the stacks at a time.
>   - We still have a serious use-after-free bug in the new stack.  This
>     may lead to kernel panic if the kernel was build with (slab? or
>     page allocation?) debugging enabled.
> Users of IP over 1394 and pro/semipro audio still need the old stack.
> Users of video should stick with the stack which their distribution has
> enabled because our support in the lowlevel libraries libraw1394 and
> libdc1394 to switch between the stacks is not quite comfortable yet.
> 
> Suspend (to RAM) and resume worked for me [TM] when I last tested them
> with each stack.  I tested i586/APM, x86-64/ACPI, and last weekend ppc32
> on 1st generation PowerBook G4.  I haven't tested hibernate (to disk)
> and restore yet.

I have never used suspend to disk on this machine. Suspend to RAM
failed when ieee1394 was loaded (or built-in) since 2.6.22 or so. 

For now I have only tested the new stack with a 6 year old 1.8" disk
and everything works, including suspend to RAM. The kernel is 2.6.25-rc4
plus additional pull from linux1394-2.6.git: 2.6.25-rc4-00032-g8d36ba4.

Thanks a lot.

	Regards,
	Gabriel

P.S: it seems that something broke in the APM emulation around rc2
on this machine, battery level reads at -1% from /proc/apm.
