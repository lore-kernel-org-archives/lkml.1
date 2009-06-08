Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbZFHKXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbZFHKXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 06:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZFHKXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 06:23:42 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:33789 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825AbZFHKXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 06:23:41 -0400
Message-ID: <4A2CE6AC.4030403@msgid.tls.msk.ru>
Date: Mon, 08 Jun 2009 14:23:40 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.30-rc8 does not boot
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I just gave 2.6.30-rc a try, taken from Linus git, tag v2.6.29-rc8.
And this one does not want to boot on my test machine which is an
AMD X2-64 with AMD780G chipset.  Neither 64 nor 32bit kernel boots.
I even tried in kvm virtual machine, -- same effect.  It freezes right
after displaying "Verifying BIOS data successful" message -- nothing
more is on the screen.

I did `make silentoldconfig' based on my current 2.6.29 configs.  In
the configs there are the following changes:
  - quite some changes in various new/changed drivers (which should
    not affect what I'm seeing)

  - decompression: I've no idea what compression it used before, but
    `make oldconfig' offered gzip by default which I accepted. Should
    I try bzip2 instead?

  - changed HZ from 100 to 300

  - also the following which I don't think I touched:

   -X86_INTERNODE_CACHE_BYTES=128
   +X86_INTERNODE_CACHE_BYTES=64

   -X86_L1_CACHE_BYTES=128
   +X86_L1_CACHE_BYTES=64

   -X86_L1_CACHE_SHIFT=7
   +X86_L1_CACHE_SHIFT=6

I'm trying different compression method for now.  If it will solve
this issue, my conclusion will be that the default value is  wrong
and - oh well - expect more reports/questions like this one :)

The rest of the system is not very interesting I think: the kernel
config is pretty generic (most stuff is in modules), compiler is
default on Debian Lenny (4.3.2-1.1).

Thanks!

/mjt
