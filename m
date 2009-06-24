Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbZFXH4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbZFXH4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 03:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbZFXH4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 03:56:41 -0400
Received: from mailhost5.gawab.com ([66.220.20.5]:55814 "HELO info14.gawab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751406AbZFXH4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 03:56:40 -0400
X-Trusted: Whitelisted
From: Al Boldi <a1426z@gawab.com>
To: Ralf Gross <Ralf-Lists@ralfgross.de>
Subject: Re: io-scheduler tuning for better read/write ratio
Date: Wed, 24 Jun 2009 10:57:41 +0300
User-Agent: KMail/1.5
References: <4A37CB2A.6010209@davidnewall.com> <x49iqinys2k.fsf@segfault.boston.devel.redhat.com> <20090624072554.GA16642@p15145560.pureserver.info>
In-Reply-To: <20090624072554.GA16642@p15145560.pureserver.info>
Cc: linux-kernel@vger.kernel.org, fengguang.wu@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906241057.41227.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf Gross wrote:
> The main problem is with bacula. It reads/writes from/to two
> spoolfiles on the same device.
>
> I get the same behavior with 2 dd processes, one reading from disk, one
> writing to it.
>
> Here's the output from dstat (5 sec intervall).
>
> --dsk/md1--
> _read _writ
>   26M   95M
>   31M   96M
>   20M   85M
>   31M  108M
>   28M   89M
>   24M   95M
>   26M   79M
>   32M  115M
>   50M   74M
>  129M   15k
>  147M 1638B
>  147M    0
>  147M    0
>  113M    0
>
>
> At the end I stopped the dd process that is writing to the device, so you
> can see that the md device is capable of reading with >120 MB/s.
>
> I did this with these two commands.
>
> dd if=/dev/zero of=test bs=1MB
> dd if=/dev/md1 of=/dev/null bs=1M

Try changing /proc/sys/vm/dirty_ratio = 1


Thanks!

--
Al

