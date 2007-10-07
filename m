Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbXJGKGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbXJGKGQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 06:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbXJGKGC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 06:06:02 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:15830 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbXJGKF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 06:05:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=S6ovPtEtPUzDnscxmYhfKBqAoyGnfGo/oRivUlzuqC8ZnPePmscWasIf7FJ9owpxjRbtFsyX2ijhXfMhVt3HEtrORJuFkvvltU5Nvkee7uIbtQS3ZtEA7zB5Y6kCPu6Y2mq3OKNBJ+p0ynAfGTV+QJmfFLLIftDnzYkDXnr2fF4=
Message-ID: <4708AF7C.5050604@gmail.com>
Date: Sun, 07 Oct 2007 12:05:48 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Kyle McMartin <kyle@mcmartin.ca>, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       arashi@sacredchao.net
Subject: Re: Revert "intel_agp: fix stolen mem range on G33"
References: <4706D4B1.6050101@sacredchao.net>	 <20071006044221.GA14767@fattire.cabal.ca>	 <20071006053410.GB14767@fattire.cabal.ca>	 <20071006054234.GC14767@fattire.cabal.ca> <47076651.8020801@gmail.com>	 <alpine.LFD.0.999.0710060858420.23684@woody.linux-foundation.org> <1191698986.5444.45.camel@koto.keithp.com>
In-Reply-To: <1191698986.5444.45.camel@koto.keithp.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2007 09:29 PM, Keith Packard wrote:
> On Sat, 2007-10-06 at 08:59 -0700, Linus Torvalds wrote:
> 
>> We do have a rule about "no regressions", so I think we'll have to do the 
>> revert, but it would be nice to hear what the consequences for the revert 
>> is for the affected hardware and new X.org..

Agree with the first part. Here comes the X log diff:
--- orig        2007-10-07 11:57:50.000000000 +0200
+++ agp 2007-10-07 11:56:07.000000000 +0200
@@ -3,7 +3,7 @@
 Release Date: 19 April 2007
 X Protocol Version 11, Revision 0, Release 1.3
 Build Operating System: Fedora Core 7 Red Hat, Inc.
-Current Operating System: Linux bellona 2.6.23-rc8-mm2_64 #58 SMP Fri Sep 28
08:52:12 CEST 2007 x86_64
+Current Operating System: Linux bellona 2.6.23-rc8-mm2_64 #59 SMP Sun Oct 7
11:43:55 CEST 2007 x86_64
 Build Date: 11 June 2007
 Build ID: xorg-x11-server 1.3.0.0-9.fc7
        Before reporting problems, check http://wiki.x.org
@@ -12,7 +12,7 @@
 Markers: (--) probed, (**) from config file, (==) default setting,
        (++) from command line, (!!) notice, (II) informational,
        (WW) warning, (EE) error, (NI) not implemented, (??) unknown.
-(==) Log file: "/var/log/Xorg.0.log", Time: Sun Oct  7 11:57:20 2007
+(==) Log file: "/var/log/Xorg.0.log", Time: Sun Oct  7 11:54:36 2007
 (==) Using config file: "/etc/X11/xorg.conf"
 (==) ServerLayout "Default Layout"
 (**) |-->Screen "Screen0" (0)
@@ -34,7 +34,8 @@
 (**) Option "BlankTime" "8"
 (**) Option "StandbyTime" "10"
 (**) Extension "Composite" is enabled
-(II) Open ACPI successful (/var/run/acpid.socket)
+(WW) Open ACPI failed (/var/run/acpid.socket) (No such file or directory)
+(II) No APM support in BIOS or kernel
 (II) Loader magic: 0x7be760
 (II) Module ABI versions:
        X.Org ANSI C Emulation: 0.3
@@ -760,18 +761,18 @@
 (II) intel(0): 0x08000000-0x09ffffff: textures (32768 kB)
 (II) intel(0): 0x10000000:            end of aperture
 drmOpenDevice: node name is /dev/dri/card0
-drmOpenDevice: open result is 10, (OK)
+drmOpenDevice: open result is 9, (OK)
 drmOpenDevice: node name is /dev/dri/card0
-drmOpenDevice: open result is 10, (OK)
+drmOpenDevice: open result is 9, (OK)
 drmOpenByBusid: Searching for BusID pci:0000:00:02.0
 drmOpenDevice: node name is /dev/dri/card0
-drmOpenDevice: open result is 10, (OK)
-drmOpenByBusid: drmOpenMinor returns 10
+drmOpenDevice: open result is 9, (OK)
+drmOpenByBusid: drmOpenMinor returns 9
 drmOpenByBusid: drmGetBusid reports pci:0000:00:02.0
 (II) intel(0): [drm] DRM interface version 1.3
 (II) intel(0): [drm] created "i915" driver at busid "pci:0000:00:02.0"
 (II) intel(0): [drm] added 8192 byte SAREA at 0x2efff000
-(II) intel(0): [drm] mapped SAREA 0x2efff000 to 0x7f794b3bb000
+(II) intel(0): [drm] mapped SAREA 0x2efff000 to 0x7fd637f76000
 (II) intel(0): [drm] framebuffer handle = 0xd4000000
 (II) intel(0): [drm] added 1 reserved context for kernel
 (II) intel(0): [drm] Registers = 0xffa80000
@@ -838,11 +839,11 @@
 (II) Initializing built-in extension DAMAGE
 (II) Initializing built-in extension XEVIE
 drmOpenDevice: node name is /dev/dri/card0
-drmOpenDevice: open result is 11, (OK)
+drmOpenDevice: open result is 10, (OK)
 drmOpenByBusid: Searching for BusID pci:0000:00:02.0
 drmOpenDevice: node name is /dev/dri/card0
-drmOpenDevice: open result is 11, (OK)
-drmOpenByBusid: drmOpenMinor returns 11
+drmOpenDevice: open result is 10, (OK)
+drmOpenByBusid: drmOpenMinor returns 10
 drmOpenByBusid: drmGetBusid reports pci:0000:00:02.0
 (WW) AIGLX: 3D driver claims to not support visual 0x23
 (WW) AIGLX: 3D driver claims to not support visual 0x24
@@ -906,7 +907,7 @@
 (II) <default pointer>: ps2EnableDataReporting: succeeded
 (II) Mouse0-usb-0000:00:1d.0-1.2/input0: Off
 (II) intel(0): [drm] removed 1 reserved context for kernel
-(II) intel(0): [drm] unmapping 8192 bytes of SAREA 0x2efff000 at 0x7f794b3bb000
+(II) intel(0): [drm] unmapping 8192 bytes of SAREA 0x2efff000 at 0x7fd637f76000
 (EE) intel(0): I830 Vblank Pipe Setup Failed 0
 (EE) intel(0): I830 Vblank Pipe Setup Failed 0
 (EE) intel(0): I830 Vblank Pipe Setup Failed 0


And it seems to work, so I think no regression here.

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
