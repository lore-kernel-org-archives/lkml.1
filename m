Return-Path: <linux-kernel-owner+w=401wt.eu-S1762824AbXJNUQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762824AbXJNUQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 16:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbXJNUQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 16:16:49 -0400
Received: from lucidpixels.com ([75.144.35.66]:39132 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbXJNUQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 16:16:48 -0400
Date: Sun, 14 Oct 2007 16:16:47 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: linux-kernel@vger.kernel.org, apiszcz@solarrain.com
Subject: Re: In response to kernel compression e-mail a few months ago.
In-Reply-To: <Pine.LNX.4.64.0710142202030.22801@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0710141609380.3935@p34.internal.lan>
References: <Pine.LNX.4.64.0710141533080.3935@p34.internal.lan>
 <Pine.LNX.4.64.0710142144340.22801@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0710141551140.3935@p34.internal.lan>
 <Pine.LNX.4.64.0710142202030.22801@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 14 Oct 2007, Jan Engelhardt wrote:

>
> On Oct 14 2007 15:53, Justin Piszcz wrote:
>>>
>>> What's with all these odd formats, and where is .zip? :)
>>> Somehow... have you tried lrzip?
>> $ apt-cache search lrzip
>> $
>>
>> I tried most of the main ones in the standard testing distribution within
>> Debian.
>
> Debian is not a solution to everything.
>
> http://ck.kolivas.org/apps/lrzip/
>

$ lrzip -L 9 linux-2.6.16.17.tar
Failed to open streams in rzip_fd
Fatal error - exiting

$ lrzip linux-2.6.16.17.tar -o linux-2.6.16.17.tar.lrz
Failed to open streams in rzip_fd
Fatal error - exiting

$ lrzip -l -L 9 linux-2.6.16.17.tar
Bus error

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
22176 abc       20   0 2197m 156m  75m R   93  4.8   0:09.17 lrzip

It must grow to 3.0GB and die (this is on an x86 host)..

$ lrzip -w 1 -l -L 9 linux-2.6.16.17.tar
linux-2.6.16.17.tar - compression ratio 3.127

$ du -sh *lrz
72M     linux-2.6.16.17.tar.lrz

$ lrzip -w 10 -l -L 9 linux-2.6.16.17.tar
linux-2.6.16.17.tar - compression ratio 3.380
$ du -sh *lrz
67M     linux-2.6.16.17.tar.lrz

Does not seem to come close unless I am doing something wrong.

Also, 7z can compress/decompress on stdin and it is multi-threaded (uses 
1.8-2.2 CPU/cores).

>> note that lrzip cannot operate on stdin/stdout

Justin.
