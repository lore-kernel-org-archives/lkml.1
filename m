Return-Path: <linux-kernel-owner+w=401wt.eu-S1764286AbYBTOh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764286AbYBTOh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 09:37:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbYBTOhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 09:37:48 -0500
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:52458 "EHLO
	QMTA05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314AbYBTOhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 09:37:47 -0500
X-Authority-Analysis: v=1.0 c=1 a=rITDv7nW5hcA:10 a=8TLePNenFDic99RKUK0A:9
 a=d4RbsQrIE7BbMYYZQWkA:7 a=bnbfXHxa-eXCAca4eyb5IkHsjaQA:4 a=igkdSQrOE6AA:10
To: linux-kernel@vger.kernel.org
CC: sam@ravnborg.org, jengelh@computergmbh.de, randy.dunlap@oracle.com,
       Valdis.Kletnieks@vt.edu
From: Karl Dahlke <eklhad@comcast.net>
Reply-to: Karl Dahlke <eklhad@comcast.net>
Subject: adapter, what's in a name
Date: Wed, 20 Feb 2008 09:37:44 -0500
Message-ID: <20080120093744.eklhad@comcast.net>
Mime-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, my mail client, edbrowse.sourceforge.net,
doesn't have a reply all function.
Never needed it.
Guess I better implement it.   :-)
Should probably take me a couple days of spare time,
if I can find a couple days of spare time;
and I'm sure other users will want it.
Meantime, I pulled the emails out of the headers and pasted them in.
Hope that reasonably works.

As was pointed out, it is difficult to place an accessibility adapter
under one particular subsystem.
Mine takes over the screen, to be a screen reader,
and it captures tty output, because it is more than just a screen reader,
it buffers output, exactly as generated, for my review.
And it uses the serial port to send text to my external synthesizer,
but sometimes it uses an on-board synth, and all this would be useless
if it didn't intercept keystrokes to read lines,
words, letters, and so on.
And I want to enhance it to do the same thing for usb keyboards.
It touches many subsystems, and doesn't belong in any one of them over the others.
It actually changes the computer, in a fundamental way.
That's why I suggested a new directory drivers/accessibility.

Here is another reason.
When you run make config, these accessibility adapters belong together logically.
CONFIG_ACCESSIBILITY
help:
Say Y here if you need to adapt this computer for a disabled user.
Saying Y will not increase the size of your kernel,
it will only offer various modules that you can use to
magnify the screen, modify the keyboard, send text to a speech synthesizer,
and so on.
If you don't anticipate any disabled users, it is ok to say N.

Most people will say N,
or perhaps M, building everything as modules in case they are needed some day.
I don't know, it just makes sense to me I guess.
If we can go along with this,
I can write a patch for drivers/Makefile and drivers/Kconfig
that would put this in place.

Karl Dahlke
