Return-Path: <linux-kernel-owner+w=401wt.eu-S1760255AbZAWCHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760255AbZAWCHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 21:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756402AbZAWCGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 21:06:54 -0500
Received: from smtpauth22.prod.mesa1.secureserver.net ([64.202.165.44]:48032
	"HELO smtpauth22.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755783AbZAWCGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 21:06:53 -0500
From: "Andrew S. Johnson" <andy@asjohnson.com>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [Bug #12426] TMDC Joystick no longer works in kernel 2.6.28
Date: Thu, 22 Jan 2009 20:06:44 -0600
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera> <200901201848.32080.andy@asjohnson.com> <alpine.LRH.1.10.0901221432320.13438@twin.jikos.cz>
In-Reply-To: <alpine.LRH.1.10.0901221432320.13438@twin.jikos.cz>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200901222006.44919.andy@asjohnson.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 January 2009 07:34:46 am Jiri Kosina wrote:
> On Tue, 20 Jan 2009, Andrew S. Johnson wrote:
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12426
> > > Subject		: TMDC Joystick no longer works in kernel 2.6.28
> > > Submitter	: Andrew S. Johnson <andy@asjohnson.com>
> > > Date		: 2009-01-10 21:53 (10 days old)
> > > References	:
> > > http://marc.info/?l=linux-kernel&m=123162486415366&w=4
> >
> > I have installed kernel 2.6.28.1, and this still does not work.
>
> What exactly doesn't work? Namely:
>
> - do you see jsX node appearing in /dev after you modprobe joydev
>   manually?

No.  Running 2.6.28.1 "find /dev -ls | grep j" returns nothing.

Running 2.6.27.9, the same "find /dev -ls | grep j" returns:

 10353    0 lrwxrwxrwx   1 root     root            9 Jan 22 18:23 /dev/js0 -> input/js0
 10347    0 crw-r--r--   1 root     root              Jan 22 18:23 /dev/input/js0
 10351    0 drwxr-xr-x   2 root     root           60 Jan 22 18:23 /dev/.udev/names/input\\x2fjs0
 10352    0 -rw-r--r--   1 root     root            0 Jan 22 18:23 /dev/.udev/names/input\\x2fjs0/\\x2fclass\\x2finput\\x2finput5\\x2fjs0
 10349    0 drwxr-xr-x   2 root     root           60 Jan 22 18:23 /dev/.udev/names/js0
 10350    0 -rw-r--r--   1 root     root            0 Jan 22 18:23 /dev/.udev/names/js0/\\x2fclass\\x2finput\\x2finput5\\x2fjs0
 10348    4 -rw-r--r--   1 root     root           66 Jan 22 18:23 /dev/.udev/db/\\x2fclass\\x2finput\\x2finput5\\x2fjs0

> - do you see the corresponding entry for the gameport in
>   /sys/bus/gameport/{devices,drivers} ?

These are almost the same when running "find /sys/bus/gameport -ls":

Kernel 2.6.28.1 (missing one line):

  9575    0 drwxr-xr-x   4 root     root            0 Jan 22 18:13 /sys/bus/gameport
  9576    0 --w-------   1 root     root         4096 Jan 22 18:16 /sys/bus/gameport/uevent
  9577    0 drwxr-xr-x   2 root     root            0 Jan 22 18:13 /sys/bus/gameport/devices
  9783    0 lrwxrwxrwx   1 root     root            0 Jan 22 18:13 /sys/bus/gameport/devices/gameport0 -> ../../../devices/pnp0/00:07/gameport0
  9578    0 drwxr-xr-x   3 root     root            0 Jan 22 18:15 /sys/bus/gameport/drivers
 12186    0 drwxr-xr-x   2 root     root            0 Jan 22 18:15 /sys/bus/gameport/drivers/tmdc
 12187    0 lrwxrwxrwx   1 root     root            0 Jan 22 18:17 /sys/bus/gameport/drivers/tmdc/module -> ../../../../module/tmdc
 12190    0 --w-------   1 root     root         4096 Jan 22 18:17 /sys/bus/gameport/drivers/tmdc/uevent
 12191    0 -r--r--r--   1 root     root         4096 Jan 22 18:17 /sys/bus/gameport/drivers/tmdc/description
 12192    0 --w-------   1 root     root         4096 Jan 22 18:17 /sys/bus/gameport/drivers/tmdc/unbind
 12193    0 --w-------   1 root     root         4096 Jan 22 18:17 /sys/bus/gameport/drivers/tmdc/bind
  9579    0 --w-------   1 root     root         4096 Jan 22 18:16 /sys/bus/gameport/drivers_probe
  9580    0 -rw-r--r--   1 root     root         4096 Jan 22 18:16 /sys/bus/gameport/drivers_autoprobe

Kernel 2.6.27.9 has one more line (see 12040):

  9489    0 drwxr-xr-x   4 root     root            0 Jan 22 18:23 /sys/bus/gameport
  9490    0 --w-------   1 root     root         4096 Jan 22 18:53 /sys/bus/gameport/uevent
  9491    0 drwxr-xr-x   2 root     root            0 Jan 22 18:23 /sys/bus/gameport/devices
  9774    0 lrwxrwxrwx   1 root     root            0 Jan 22 18:23 /sys/bus/gameport/devices/gameport0 -> ../../../devices/pnp0/00:07/gameport0
  9492    0 drwxr-xr-x   3 root     root            0 Jan 22 18:23 /sys/bus/gameport/drivers
 12039    0 drwxr-xr-x   2 root     root            0 Jan 22 18:23 /sys/bus/gameport/drivers/tmdc
 12040    0 lrwxrwxrwx   1 root     root            0 Jan 22 18:53 /sys/bus/gameport/drivers/tmdc/gameport0 -> ../../../../devices/pnp0/00:07/gameport0
 12078    0 lrwxrwxrwx   1 root     root            0 Jan 22 18:53 /sys/bus/gameport/drivers/tmdc/module -> ../../../../module/tmdc
 12081    0 --w-------   1 root     root         4096 Jan 22 18:53 /sys/bus/gameport/drivers/tmdc/uevent
 12082    0 -r--r--r--   1 root     root         4096 Jan 22 18:53 /sys/bus/gameport/drivers/tmdc/description
 12083    0 --w-------   1 root     root         4096 Jan 22 18:53 /sys/bus/gameport/drivers/tmdc/unbind
 12084    0 --w-------   1 root     root         4096 Jan 22 18:53 /sys/bus/gameport/drivers/tmdc/bind
  9493    0 --w-------   1 root     root         4096 Jan 22 18:53 /sys/bus/gameport/drivers_probe
  9494    0 -rw-r--r--   1 root     root         4096 Jan 22 18:53 /sys/bus/gameport/drivers_autoprobe

If there is anything else I can provide, please let me know.

Andy Johnson


