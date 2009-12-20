Return-Path: <linux-kernel-owner+w=401wt.eu-S1751637AbZLTLKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637AbZLTLKm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 06:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbZLTLKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 06:10:41 -0500
Received: from isrv.corpit.ru ([81.13.33.159]:46767 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbZLTLKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 06:10:40 -0500
Message-ID: <4B2E062C.1040106@msgid.tls.msk.ru>
Date: Sun, 20 Dec 2009 14:10:36 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Johannes Stezenbach <js@sig21.net>
CC: Sam Ravnborg <sam@ravnborg.org>, Michael Guntsche <mike@it-loops.com>,
       Oliver Hartkopp <oliver@hartkopp.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, mmarek@suse.cz
Subject: Re: 2.6.33-rc1 Reboot right after bootloader
References: <20091219233457.GA4288@trillian.comsick.at> <20091220084656.GA485@merkur.ravnborg.org> <20091220091019.GA20246@sig21.net> <4B2DFEB7.4080507@msgid.tls.msk.ru>
In-Reply-To: <4B2DFEB7.4080507@msgid.tls.msk.ru>
X-Enigmail-Version: 0.95.0
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote:
[]
> So now I don't know what to do.  According to the standard, there's
> no utility that will work here. ;)  Maybe the attached (together
> with 4a2ff67c88211026afcbdbc190c13f705dae1b59) will make everyone happy?

--- a/scripts/Makefile.lib.orig	2009-12-19 18:36:01.944153109 +0300
+++ a/scripts/Makefile.lib	2009-12-20 13:36:04.014530573 +0300
@@ -215,6 +215,6 @@
 	dec_size=$$(expr $$dec_size + $$fsize);				\
 done;									\
-printf "%08x" $$dec_size |						\
-	sed 's/\(..\)\(..\)\(..\)\(..\)/\\\\x\4\\\\x\3\\\\x\2\\\\x\1/g'	\
+printf "%012o" $$dec_size |						\
+	sed 's/\(...\)\(...\)\(...\)\(...\)/\\\\4\\\\3\\\\2\\\\1/g'	\
 )

Apparently that does not work with dash either.  It produces \4\3\2\1:

$ tail -c 4 arch/x86/boot/compressed/vmlinux.bin.lzma | hexdump
0000000 0304 0102

That's insane.

How about removing the whole hack and keeping the uncompressed size in
another file?  (I'll try to cook something today - it requires a bit
more changes than the 2-liner above).

/mjt
