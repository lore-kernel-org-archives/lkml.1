Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab0BRDkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 22:40:20 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:52602 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab0BRDkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 22:40:18 -0500
From: Goswin von Brederlow <goswin-v-b@web.de>
To: Frans Pop <elendil@planet.nl>
Cc: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, kyle@moffetthome.net,
       neilb@suse.de, babydr@baby-dragons.com, davidsen@tmr.com,
       volkerarmin@googlemail.com, mjevans1983@gmail.com,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: Linux mdadm superblock question.
References: <201002140251.59668.volkerarmin@googlemail.com>
	<4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
	<201002141940.35716.volkerarmin@googlemail.com>
	<4B7AD35E.7000405@tmr.com>
	<alpine.LNX.2.01.1002161541370.24961@filesrv1.baby-dragons.com>
	<20100217130103.3ca65ef3@notabene.brown>
	<f73f7ab81002162234t531203ccue1f9ecc839c8ae42@mail.gmail.com>
	<f73f7ab81002162234t531203ccue1f9ecc839c8ae42@mail.gmail.com>
	<4B7BB927.5000305@grumpydevil.homelinux.org>
	<201002171426.47981.elendil@planet.nl>
	<20100217205406.GA13287@twister.home>
Date: Thu, 18 Feb 2010 04:40:16 +0100
In-Reply-To: <20100217205406.GA13287@twister.home> (Gabor Gombas's message of
	"Wed, 17 Feb 2010 21:54:06 +0100")
Message-ID: <87ocjn9ppb.fsf@frosties.localdomain>
User-Agent: Gnus/5.110009 (No Gnus v0.9) XEmacs/21.4.22 (linux, no MULE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX1/1Ll6qZfu/gLBFcPeMXwBpmlD5grjBHyPRYlAo
	2wOq+9Y1wdK+vmYr4lNXqXpyLPITYyrIwCpYqEt6m02/B7xGqL
	2w0E3N900=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabor Gombas <gombasg@digikabel.hu> writes:

> On Wed, Feb 17, 2010 at 02:26:46PM +0100, Frans Pop wrote:
>
>> That's simply not true, at least not for Debian. If you actually use the 
>> distro tools [1] the only assumptions are made at kernel *installation* 
>> time, not at kernel build time.
>
> And that's why network-booted diskless clients and virtual guests have
> all sort of useless modules loaded; the HW where the kernel package was
> installed in this case is very different from the HW where the kernel
> will run. If only there were a switch to prohibit ever looking at the
> current machine's configuration when generating the initramfs...

>From my experience you must boot up your client/guest and install the
kernel in there. Then copy the kernel and initrmafs over to the boot
server for use.

Initramfs was never designed to generate an image for another system, or
worse, for a pool of different systems. You can probably make it work on
a case by case basis but that wasn't thought of during the design phase.

Interesting idea though.

>> I've been using initramfs-tools generated initrds for years without 
>> problems, and that includes "root on LVM on LUKS encrypted partition" 
>> and "root on LVM on RAID" setups.
>
> I've tried a couple of times to use a Debian-built initramfs with a
> custom built kernel. The kernel worked fine without an initramfs (it had
> everything built in), but it did not boot with the initramfs.
>
> Gabor

'make-kpkg ... --initrd kernel-image' should build you your custom
kernel with all the magic required to generate a working initramfs.
If not then please do file bugs.

MfG
        Goswin
