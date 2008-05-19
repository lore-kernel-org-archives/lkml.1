Return-Path: <linux-kernel-owner+w=401wt.eu-S1764222AbYESXpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764222AbYESXpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 19:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760725AbYESXpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 19:45:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50083 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760482AbYESXp2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 19:45:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH, RFC] char dev BKL pushdown
Date: Tue, 20 May 2008 01:07:49 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       Wim Van Sebroeck <wim@iguana.be>
References: <13762.1211142411@vena.lwn.net>
In-Reply-To: <13762.1211142411@vena.lwn.net>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805200107.51659.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+vjlDNts6v8a2x980pNz0zw+kWatelzEC6rHy
 kLI+F9jX+g2k8//pb427Uj9wlH8n+PioBW5zGv/4uK8sNbAwFn
 TKcp9JOeRytHfSGHPUzvA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 May 2008, Jonathan Corbet wrote:
> There's a few intermediate dispatcher levels like this, actually.
> Lots of video drivers get called behind video_open(), usb drivers from
> usb_open(), etc.  Not much to be done but to push things down one level
> at a time.

I've given it a try for all the misc drivers that have an open() function.
The vast majority of them are actually watchdog drivers, all of which
register as a misc device by themselves. You seem to already have a script
to turn per-file changes into a patch each, so I'm sending you two patches:
one for all the watchdog drivers (maybe Wim can take care of that as well)
and one for all the other misc drivers (this one needs to be split).

	Arnd <><

