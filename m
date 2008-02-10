Return-Path: <linux-kernel-owner+w=401wt.eu-S1757129AbYBJVEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129AbYBJVEm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 16:04:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756849AbYBJVEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 16:04:31 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:44190 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818AbYBJVE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 16:04:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=fziSSjhKDpVLF9QjphbVmg31MUNgwUV798N10k/u19AhiyJlZlOqILDv3YV/ahvHOSu4wI3bZ9Xlu9xJpL/TsOND5NLPiuIfCpToC8COHxnyyTsdn9k8U9ByY+xm7HepPqK6+W71E9W3N6+sq0wrr4ZAoKuMWl7GIOfXOzRLmbQ=
Message-ID: <76366b180802101304j359e2873vd9dd974920bf6745@mail.gmail.com>
Date: Sun, 10 Feb 2008 16:04:25 -0500
From: "Andrew Paprocki" <andrew@ishiboo.com>
To: linux-kernel@vger.kernel.org
Subject: I/O collisions w/ hwmon/it87.c and watchdog/it8712f_wdt.c? (Super I/O chips in general..)
Cc: "Jorge Boncompte" <jorge@dti2.net>, "Jean Delvare" <khali@linux-fr.org>,
       "Chris Gauthron" <chrisg@0-in.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: fa0fade774353ce7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm interested in expanding the current support for the it87 Super I/O
chip to provide access to more of its capabilities. I started by
looking at two existing drivers which talk to different parts of the
chip. Maybe I'm missing something, but what guarantees that both of
these drivers won't attempt to talk to the chip at the same time?

The watchdog/it8712f_wdt.c driver has an internal spinlock, the
hwmon/it87.c driver doesn't, and I don't see how a lock could be
shared across both unless it is taken care of at a lower level that
I'm not aware of. You can see that code is essentially copied between
the two files to talk to the chip.

This brings me to a more general question regarding SuperI/O chips.
Since these chips touch many different parts of traditionally separate
driver areas, how should the drivers be structured so that they can
all talk to the chip? Should the low level communications routines for
the chip live in a library which all the drivers could use? Should all
of the created devices live inside one file? (e.g. platform/it87.c
instead of hwmon, watchdog, etc)

Thanks,
-Andrew
