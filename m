Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbYBKIlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbYBKIlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 03:41:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbYBKIkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 03:40:55 -0500
Received: from smtp-101-monday.nerim.net ([62.4.16.101]:55515 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751386AbYBKIky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 03:40:54 -0500
Date: Mon, 11 Feb 2008 09:40:51 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Andrew Paprocki" <andrew@ishiboo.com>
Cc: linux-kernel@vger.kernel.org, "Jorge Boncompte" <jorge@dti2.net>,
       Jim Cromie <jim.cromie@gmail.com>, Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: I/O collisions w/ hwmon/it87.c and watchdog/it8712f_wdt.c?
 (Super I/O chips in general..)
Message-ID: <20080211094051.147ce36f@hyperion.delvare>
In-Reply-To: <76366b180802101304j359e2873vd9dd974920bf6745@mail.gmail.com>
References: <76366b180802101304j359e2873vd9dd974920bf6745@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Sun, 10 Feb 2008 16:04:25 -0500, Andrew Paprocki wrote:
> I'm interested in expanding the current support for the it87 Super I/O
> chip to provide access to more of its capabilities. I started by
> looking at two existing drivers which talk to different parts of the
> chip. Maybe I'm missing something, but what guarantees that both of
> these drivers won't attempt to talk to the chip at the same time?

Nothing guarantees it in general. However, at least most hwmon drivers
avoid accessing the Super-I/O configuration space after driver
initialization, which happens when the module is loaded. As module
loading is serialized, this limits the risk of concurrent access.

This is however a limitation I'd be happy to get rid of. It would be
nice to be able to access some configuration space registers at
run-time (e.g. VID readings).

> The watchdog/it8712f_wdt.c driver has an internal spinlock, the
> hwmon/it87.c driver doesn't, and I don't see how a lock could be
> shared across both unless it is taken care of at a lower level that
> I'm not aware of. You can see that code is essentially copied between
> the two files to talk to the chip.
> 
> This brings me to a more general question regarding SuperI/O chips.
> Since these chips touch many different parts of traditionally separate
> driver areas, how should the drivers be structured so that they can
> all talk to the chip? Should the low level communications routines for
> the chip live in a library which all the drivers could use? Should all
> of the created devices live inside one file? (e.g. platform/it87.c
> instead of hwmon, watchdog, etc)

You probably want to discuss this with Jim Cromie and Hans de Goede
(Cc'd.) They have been discussing a possible implementation in October
2007 on the lm-sensors list:

http://lists.lm-sensors.org/pipermail/lm-sensors/2007-October/021561.html
http://lists.lm-sensors.org/pipermail/lm-sensors/2007-October/021562.html
http://lists.lm-sensors.org/pipermail/lm-sensors/2007-October/021563.html
http://lists.lm-sensors.org/pipermail/lm-sensors/2007-October/021564.html
http://lists.lm-sensors.org/pipermail/lm-sensors/2007-October/021565.html
http://lists.lm-sensors.org/pipermail/lm-sensors/2007-October/021566.html

-- 
Jean Delvare
