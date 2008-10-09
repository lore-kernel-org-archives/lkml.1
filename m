Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbYJIUSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbYJIUSp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 16:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbYJIUSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 16:18:36 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:25169 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbYJIUSf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 16:18:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=LYB0GiwLKo9cyP3XlyD9rOMgEpXJxyA9KhZleqFHKYIeeD3gUrjrigo5GgD/XTituf
         EFHVvnSnHa/0Q6X57Gxxf3kcA5zKPdbAOgiS8tA4qjIgXQZDI3SqWktxV4XuD4pbFfNv
         foTsdU18roX4w3EZlZvLh9b5j1pz5g4fVtNpA=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: loading ipmi_watchdog causes tons of other watchdog modules to be loaded
Date: Thu, 9 Oct 2008 22:18:28 +0200
User-Agent: PLD Linux KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <200810091348.19828.a.miskiewicz@gmail.com> <200810092102.16110.a.miskiewicz@gmail.com> <ac3eb2510810091209rd76c8a4j83a6a48d5db5d4f9@mail.gmail.com>
In-Reply-To: <ac3eb2510810091209rd76c8a4j83a6a48d5db5d4f9@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810092218.29000.a.miskiewicz@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 of October 2008, Kay Sievers wrote:
> On Thu, Oct 9, 2008 at 9:02 PM, Arkadiusz Miskiewicz
>
> <a.miskiewicz@gmail.com> wrote:
> > On Thursday 09 October 2008, Kay Sievers wrote:
> >> On Thu, Oct 9, 2008 at 7:22 PM, Arkadiusz Miskiewicz
> >>
> >> > ... but that ipmi_watchdog is the correct driver that handles
> >> > /dev/watchdog, so this shouldn't be happening, correct?
> >>
> >> While the driver you expect to work is loaded, what does:
> >>   ls -l /dev/watchdog
> >> print?
> >>
> >> If the devno of this node is 10:130, what does:
> >>   find /sys/class /sys/devices/ -name dev | xargs grep 10:130
> >> print?
> >
> > # ls -l /dev/watchdog
> > crw------- 1 root root 10, 130 sie  8 17:00 /dev/watchdog
> > # find /sys/class /sys/devices/ -name dev | xargs grep 10:130
> > /sys/class/misc/watchdog/dev:10:130
>
> Ok, so you actually have a driver bound to that device number, and it
> should not trigger the usual module autoloading mechanism.
>
> What does:
>   ls -l /sys/class/misc/watchdog/

# ls -l /sys/class/misc/watchdog/
razem 0
-r--r--r-- 1 root root 4096 paź  9 22:02 dev
drwxr-xr-x 2 root root    0 paź  9 22:02 power
lrwxrwxrwx 1 root root    0 paź  9 22:22 subsystem -> ../../misc
-rw-r--r-- 1 root root 4096 paź  9 22:02 uevent


> and
>   ls -l /sys/class/misc/watchdog/device/
> print?

# LC_ALL=C ls -l /sys/class/misc/watchdog/device/
ls: cannot access /sys/class/misc/watchdog/device/: No such file or directory


> Does the /sys/class/misc/watchdog/ directory exist, before you load
> the module you expect to be the driver behind /dev/watchdog?

It doesn't exist before. modprobe ipmi_watchdog, 
then /sys/class/misc/watchdog/ becomes available.

> To clarify, the other modules get loaded, after you loaded but module,
> the above /sys/class/misc/watchdog/ directory exists, and only if you
> read from the device, all the other modules get loaded?

Exactly.  I load ipmi_watchdog, /sys/class/misc/watchdog/ becomes available 
(no /sys/class/misc/watchdog/device/ though), then cat /dev/watchdog and this 
causes that other watchdog modules are loaded.

> Kay

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
