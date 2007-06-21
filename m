Return-Path: <linux-kernel-owner+w=401wt.eu-S1758716AbXFUU5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbXFUU5v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 16:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755910AbXFUU5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 16:57:43 -0400
Received: from ms.trustica.cz ([82.208.32.68]:50555 "EHLO ms.trustica.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097AbXFUU5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 16:57:42 -0400
Message-ID: <467AE640.9090409@assembler.cz>
Date: Thu, 21 Jun 2007 22:57:36 +0200
From: Rudolf Marek <r.marek@assembler.cz>
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: Soeren Sonnenburg <kernel@nn7.de>
CC: lkml <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] hwmon/coretemp: Fix a broken error path - microcode update
 fix
References: <1182026585.4230.8.camel@localhost>	 <20070616231745.1b0f7bd9@hyperion.delvare>	 <1182071803.4815.5.camel@localhost>  <467575BF.1090207@assembler.cz> <1182335403.21563.99.camel@localhost>
In-Reply-To: <1182335403.21563.99.camel@localhost>
Content-Type: multipart/mixed;
 boundary="------------080108010306050006020209"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080108010306050006020209
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit

Hello Soeren,

Sorry for the delay.

I'm ccing all lists maybe some other people are interested. There is known 
errata AE18 which prevents coretemp from working correctly on some mobile Core 
processors (family 6 model e). My driver refuses to load and now thanks to 
soeren will not crash ;) However what to do when no microcode update (no new 
BIOS) is available?

Soeren pointed at some T60, T60p BIOS update and luckily, there is a easy way 
how to extract the microcode update and even convert it into the .txt format as 
microcode update utility (http://www.urbanmyth.org/microcode/) expects.
Attached scripts generates the mcode.txt file which may be used by the update 
utility. Please can you give a try?

It seems that there is microcode update for CPUID 06E8 version 0x39 just as my 
driver is checking. So if your CPUID is 06e8 too you should get the coretemp 
driver working.

If so I will post a patch and document the script in documentation directory (or 
at least some general instructions how to do that)

Please tell me your stepping:
cat /proc/cpuinfo  | grep stepping

Thanks,

Rudolf



--------------080108010306050006020209
Content-Type: text/plain;
 name="gen_mcode.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gen_mcode.txt"

#!/bin/bash

#get the BIOS http://www-307.ibm.com/pc/support/site.wss/MIGR-63024.html
wget ftp://ftp.software.ibm.com/pc/pccbbs/mobiles/79uj20us.exe
cabextract -F "*PAT" 79uj20us.exe
 ls -1 *PAT | while read line; do echo "/* Microcode from $line */" ;  hexdump -e  ' 4/4 "0x%08X, " "\n"'  $line ;done >mcode.txt

--------------080108010306050006020209--
