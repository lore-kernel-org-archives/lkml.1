Return-Path: <linux-kernel-owner+w=401wt.eu-S1761604AbXGFOVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761604AbXGFOVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 10:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbXGFOVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 10:21:05 -0400
Received: from mathups.math.u-psud.fr ([129.175.52.4]:64008 "EHLO
	matups.math.u-psud.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752795AbXGFOVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 10:21:04 -0400
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: mikie <mikie.pl@gmail.com>
Subject: Re: understanding firmware loader for speedtouch (kernel 2.6.21.5)
Date: Fri, 6 Jul 2007 16:20:43 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <ca35ce500707060554v71ebdca3k8ef18e4c0a44c9cb@mail.gmail.com>
In-Reply-To: <ca35ce500707060554v71ebdca3k8ef18e4c0a44c9cb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707061620.44348.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 6 July 2007 14:54:18 mikie wrote:
> Hi,
> 
> I experience some problems with the speedtch.c module, especially in
> regards to its firmware loader.
> I am not quite sure if this module is going to load the firmware
> itself or does it use some external software to do that ?

It loads it itself, using some external software!
 
> All I get is :
> 
> Jul  6 13:41:37 srv kernel: speedtch 1-2:1.0: speedtch_find_firmware:
> looking for speedtch-1.bin.2.00
> [...]
> Jul  6 13:42:19 srv kernel: speedtch 1-2:1.0: speedtch_find_firmware:
> looking for speedtch-1.bin.2
> [...]
> Jul  6 13:43:19 srv kernel: speedtch 1-2:1.0: speedtch_find_firmware:
> looking for speedtch-1.bin
> 
> And nothing more happens. The firmware does not get loaded to the
> modem. There is also no information in the logs that the firmware
> loading failed...

It should either print:
	no stage 1 firmware found!
or
	found stage 1 firmware <name>
Does it really print neither?  If so, that must mean that the
firmware loader got stuck.

> I have read and checked the firmware.agent script from some hotplug
> package, and noticed that it makes something like simple file copy of
> the firmware to the "data" and echoing 1 or 0 to the "loading" file.
> But what is the location of these data/loading ? Also the firmware is
> split into 2 parts -- should I upload them one after another? Is that
> all that should be done to get the firmware loaded?

You need to write the file that was asked for: the modem starts by asking
for the first file, uploads it, then asks for the second file and uploads it.
The file is written to the "data" file, but note that the data file is created
on the fly when the modem requests a firmware load so you can't write to it
at some random time.

Ciao,

Duncan.
