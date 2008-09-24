Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbYIXN7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbYIXN7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 09:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbYIXN7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 09:59:14 -0400
Received: from smtp.inet.fi ([192.89.123.192]:46023 "EHLO
	gulo-int.media.sonera.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752112AbYIXN7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 09:59:13 -0400
X-Greylist: delayed 2120 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Sep 2008 09:59:13 EDT
Message-ID: <48DA3FB4.1060207@gmail.com>
Date: Wed, 24 Sep 2008 16:25:08 +0300
From: tike64@gmail.com
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: KDGKBENT and unicode
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear linux-kernel,

I am trying to read keyboard in raw mode (K_MEDIUMRAW, to be exact). I 
hope to avoid reading all the keymaps from the kernel to the application 
for keycode translation. Therefore I call KDGKBENT ioctl for every 
keycode I get from the tty. Basically this works except, when the 
translation result is an unicode keysym or should I say the unicode 
value happens to be greater than 0xFF, I get K_HOLE.

This observation seems to be in harmony with the drivers/char/vt_ioctl.c 
code. There I learned that, if I had the keyboard in the K_UNICODE mode, 
I could get directly the 16 bit unicode values.

So I have two options:

1) Read the keymaps in K_UNICODE mode and do the translations myself 
while in K_MEDIUMRAW mode

2) For each keycode switch to K_UNICODE mode, ask the translation from 
kernel, switch back to K_MEDIUMRAW mode and read the next keycode (the 
continuous switching might have severe side effects).

The question is am I correct so far or am I miserably confused? Aren't 
there any smarter ways to do the translation?

The next question probably must be how do I handle CAPS with kernel 
keymaps? As the CAPS sensitivity is encoded in the type field of keysym 
value, it is lost when the value is 16 bit unicode. I am seeing this 
phenomenon in ordinary VT when I manage to load some keysyms as 16 bit 
unicode.

--

Timo
