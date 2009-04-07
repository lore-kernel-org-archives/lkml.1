Return-Path: <linux-kernel-owner+w=401wt.eu-S1757761AbZDGT5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761AbZDGT5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 15:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbZDGT5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 15:57:09 -0400
Received: from mailfe15.tele2.it ([212.247.155.205]:37662 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752635AbZDGT5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 15:57:08 -0400
X-Greylist: delayed 3604 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Apr 2009 15:57:08 EDT
X-Cloudmark-Score: 0.000000 []
X-Cloudmark-Analysis: v=1.0 c=1 a=5OFHYswelGgA:10 a=uVG3iVQp83oA:10 a=8hWvghSQAAAA:8 a=t2g_X5M5wnNHXu2OfLYA:9 a=S88Xux0CGMRWUpaNqscjAtUn1cgA:4 a=4W84yQIDYkUA:10
Message-ID: <49DBA1E4.8000502@gmail.com>
Date: Tue, 07 Apr 2009 20:56:36 +0200
From: Massimo Maiurana <maiurana@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: sam@ravnborg.org
CC: linux-kernel@vger.kernel.org
Subject: kconfig: update-po-config broken in 2.6.29
X-Enigmail-Version: 0.95.6
OpenPGP: id=7044D601
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
in latest 2.6.29 "make update-po-config" fails at msguniq invocation 
with an "invalid control sequence" error.
the offending string is the following, and it's located in 
drivers/staging/panel/Kconfig:72:
"'\e[L' which are specific to the LCD, and a few ANSI codes. The"

looks to me like gettext expects strings in printf format, so in 
this case it thinks "\e" is a control sequence but doesn't recognise 
it as a valid one.

I can still obtain a suitable linux.pot file escaping the backslash, 
and the resulting linux.mo file works even if the string is again 
unescaped, but of course if I leave the escaped string it will be 
displayed as-is (with a double backslash) if i run a configurator in 
english, so it is not a valid solution for a patch.

Maybe a valid solution would be to tell kxgettext to automatically 
escape this kind of strings in the */config.pot he produces, so that 
msguniq would not complain?... I don't really know, and I don't even 
know how to do it. I see there is an escape function right at the 
top of kxgettext.c, but as I'm not a coder I don't really know how 
to hack it, so it's up to you... sorry.

-- 
       Massimo Maiurana         massimo<at>ragusa.linux.it
       http://massimo.solira.org       GPG keyID #7044D601

Articolo 33 - [...]Enti e privati hanno il diritto di istituire
scuole ed istituti di educazione, senza oneri per lo Stato.[...]
