Return-Path: <linux-kernel-owner+w=401wt.eu-S1758128AbYF1Rs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128AbYF1Rs1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 13:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbYF1RsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 13:48:18 -0400
Received: from mail.dunaweb.hu ([81.17.184.3]:36228 "EHLO mail.dunaweb.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023AbYF1RsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 13:48:18 -0400
X-Greylist: delayed 358 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Jun 2008 13:48:17 EDT
Message-ID: <486677F7.6080004@dunaweb.hu>
Date: Sat, 28 Jun 2008 19:42:15 +0200
From: Zoltan Boszormenyi <zboszor@dunaweb.hu>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Mickey mouse voices on snd-intel8x0
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a Compaq Deskpro EN with PIII/866 recycled as a thin client.
The problem was that sound on the thin client was played faster than it
should.
I have Fedora 9/x86-64 on the main machine, so the thin client is LTSP5
that comes with F9.
I tried everything (acpi=off, etc) but the strange voice didn't get better.
I discovered this in the dmesg:

intel8x0_measure_ac97_clock: measured 50895 usecs
intel8x0: measured clock 78 rejected
intel8x0: clocking to 48000

I looked at the current kernel sources and found the solution for that.
I had to provide this for the thin client in
/opt/ltsp/i386/etc/modprobe.conf :

options snd-intel8x0 ac97_clock=44100

# lspci -s 00:1f.5
00:1f.5 Multimedia audio controller: Intel Corporation 82801BA/BAM AC'97
Audio Controller (rev 02)
# lspci -ns 00:1f.5
00:1f.5 0401: 8086:2445 (rev 02)

Best regards,
Zoltán Böszörményi

