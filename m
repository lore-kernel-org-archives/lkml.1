Return-Path: <linux-kernel-owner+w=401wt.eu-S1759797AbYJVVMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759797AbYJVVMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 17:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbYJVVM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 17:12:26 -0400
Received: from hobbit.corpit.ru ([81.13.33.150]:21595 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759474AbYJVVMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 17:12:25 -0400
Message-ID: <48FF9737.5050207@msgid.tls.msk.ru>
Date: Thu, 23 Oct 2008 01:12:23 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: input devices handling
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Similar question has been asked already by me in the past,
regarding "conversions" of ACPI button events to "keyboard
events".  The talk is about how one is supposed to handle
various "common" "meta-buttons" like Power, Sleep, and so
on.

Before, there was /proc/acpi/event and /etc/acpid/* stuff,
and it was easy (but somewhat clumsy) to act to system power
down button.  But the "proper way" now is to handle
/dev/input/event* interface, because such "Power" button can
be on a keyboard, on a remote control, and so on.  I understand
the idea, and I like it.

But now the question.  How one supposed to find all the devices
which generate such events?  I mean not about scanning the /dev
directory, which can be done once at startup, but about REscanning
it to find which NEW keyboards and the like appeared since last
(re)scan and which were removed.

For mouse, there is /dev/[input/]mice, which is a meta-device
for all mouse-like devices out there, and it actually works.
For an application that reacts to system button events, there
is no such device, and the only way is to scan all keyboard-like
devices and open them all (well, only ones which actually have
the buttons in question, but that's minor detail).

So now I have to know WHEN to (re)scan the devices.  Should I
depend on udevd/hald for that (i really dislike this way)?
Or should I just rescan periodically, say, every 10 sec or
so?  Or is there other, better way?

The only thing I need so far is to be able to shut down the
machine on a power down button.  Maybe in the future something
like changing audio volume etc will be of interest too, but
that should be pretty similar.

Thanks!

/mjt
