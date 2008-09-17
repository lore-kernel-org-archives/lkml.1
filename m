Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbYIQSEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbYIQSEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 14:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754269AbYIQSEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 14:04:14 -0400
Received: from pih-relay04.plus.net ([212.159.14.17]:56583 "EHLO
	pih-relay04.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbYIQSEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 14:04:13 -0400
Message-ID: <48D14698.60601@yahoo.com>
Date: Wed, 17 Sep 2008 19:04:08 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
Newsgroups: fa.linux.kernel
CC: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>,
       acpi4asus-user@lists.sourceforge.net
Subject: Re: Turning off camera also kills card reader on EeePC 900
References: <fa.DzjC5FQ8ty+cqmv5KG/NRpAWgdE@ifi.uio.no> <fa.+Dv7n0Sa7hzDrReJcnf4HgYqsoA@ifi.uio.no> <fa.+GChIGFRZ5au1CMIOZvlKhwFPrU@ifi.uio.no> <fa.jNQrULYfenJPvj20234NL8Nt+cM@ifi.uio.no> <fa.QFFph3ZzzmbGalzypmWpsSRfEPY@ifi.uio.no> <fa.Pwdn/v9TPDX5WUUVn7K6FAfABEg@ifi.uio.no>
In-Reply-To: <fa.Pwdn/v9TPDX5WUUVn7K6FAfABEg@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: 83ff89bf07bea32cd0db9ed2b4aae6f6
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Alan Jenkins wrote:
>> Sitsofe Wheeler wrote:
>>>
>>> Alan Jenkins wrote:
>>>
>>>> - It might be necessary to compare with the pre-installed OS
>>>>  - Is the pre-installed kernel any better (files might be under
>>>> /proc/acpi/asus instead)?  I guess you might not have the time or
>>>> resources to test that though.
>>>
>>> The Xandros 2.6.21.4-eeepc install has the following files in 
>>> /proc/acpi/asus/
>>> brn camera cardr cpufv disp hdps init type wlan
>>>
>>> I have no idea what cpufv, disp, hdps, init or type are. Doing echo 1 
>>> > camera && echo 0 > camera under this setup does NOT disappear the 
>>> SD card.
>> Rats.  So there is some secret the mainline driver is missing :-(.

So I got around to downloading those my 4 pieces of rar and poking about 
the source. For those who are curious inside the rars is a tar.bz2 file 
of a tree of .debs. A few hints:

DON'T download the source from China if you aren't in China it's very slow.
The global mirrors are hidden behind javascript for some reason whereas 
the Chinese ones are not. Still don't be tempted if you aren't in Japan 
- the downloads were frequently crawling along at less than 
10Kbyte/second and would periodically disconnect themselves.

The bad news for me is that part4 of the .rar archive was always corrupt 
(I redownloaded it and it was still corrupt). The good news is that I 
was able to extract some of the archive.

Here are the much faster links that worked for me:
http://dlcdnet.asus.com/pub/ASUS/EeePC/EeePC900/Eee_PC_900_source_code_part1.rar
http://dlcdnet.asus.com/pub/ASUS/EeePC/EeePC900/Eee_PC_900_source_code_part2.rar
http://dlcdnet.asus.com/pub/ASUS/EeePC/EeePC900/Eee_PC_900_source_code_part3.rar
http://dlcdnet.asus.com/pub/ASUS/EeePC/EeePC900/Eee_PC_900_source_code_part4.rar

MD5SUMs of the good pieces of the above:
48bf55be427b279abfc641c10fe4b0ef  Eee_PC_900_source_code_part1.rar
56f8f02cf601c6d82fe4ef824e0b5625  Eee_PC_900_source_code_part2.rar
560d151a90b70b5edabdd9f70cfe7567  Eee_PC_900_source_code_part3.rar

SHA1SUMs of the good pieces of the above:
e6983951b556456677b4d5a77608bc117f3ffe91  Eee_PC_900_source_code_part1.rar
04ec1d1af1014f87ad54476882428ed5090f1742  Eee_PC_900_source_code_part2.rar
09d3b4c1f5356b068d4bfdf4c51dc481b53c5661  Eee_PC_900_source_code_part3.rar

In the linux-source deb there is a folder which contains patches against 
2.6.21.4. For short term convenience I have temporarily repackaged the 
patches here: 
http://sucs.org/~sits/test/eeepc-900/eeepc-kernel-patches.tar.gz 
(contains ALSA patches for the realtek intel_hda, the elantech touchpad 
driver, a pci message patch(?), huawei_usb_storage storage patch (?), 
unionfs patches and aufs patches and a kernel config file).

There is also a separate asus-acpi deb which I have temporarily repacked 
on http://sucs.org/~sits/test/eeepc-900/asus-acpi-p9xx_1.2-1_i386.tar.gz 
. Sadly it seems to contain a prebuilt asus_acpi.ko in /lib/modules 
(along with various scripts to respond to hotkeys etc).
