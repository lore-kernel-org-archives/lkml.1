Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbXJCOES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbXJCOES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 10:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbXJCOEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 10:04:10 -0400
Received: from hpsmtp-eml15.kpnxchange.com ([213.75.38.115]:51321 "EHLO
	hpsmtp-eml15.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754777AbXJCOEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 10:04:09 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: top displaying 9999% CPU usage
Date: Wed, 3 Oct 2007 16:04:07 +0200
User-Agent: KMail/1.9.7
References: <200710031433.34504.elendil@planet.nl> <4703932C.6060900@ums.usu.ru>
In-Reply-To: <4703932C.6060900@ums.usu.ru>
Cc: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710031604.07365.elendil@planet.nl>
X-OriginalArrivalTime: 03 Oct 2007 14:04:07.0603 (UTC) FILETIME=[439C2830:01C805C6]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 October 2007, you wrote:
> Try to capture the i/o log with the following command:
> strace -o top.log top

Thanks for the suggestion.

> This will show for sure whether the kernel gives out incorrect data or
> top misinterprets them.

 PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
5269 fjp       20   0  442m  61m  33m S 9999  3.1   0:34.12 kontact

Here are the last two reads for PID 5269 from /proc before that:

15:48:51 stat("/proc/5269", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
15:48:51 open("/proc/5269/stat", O_RDONLY) = 10
15:48:51 read(10, "5269 (kontact) S 1 5100 5100 0 -1 4202560 58186 7891 290 1 2911 502 10 15 20 0 6 0 9225 464408576 15694 18446744073709551615 4194304 4365900 140733817144688 18446744073709551615 47998530367074 0 0 4098 83113 18446744073709551615 0 0 17 1 0 0 0\n", 1023) = 244
15:48:51 open("/proc/5269/statm", O_RDONLY) = 10
15:48:54 stat("/proc/5269", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
15:48:54 open("/proc/5269/stat", O_RDONLY) = 10
15:48:54 read(10, "5269 (kontact) S 1 5100 5100 0 -1 4202560 58186 7891 290 1 2912 500 10 15 20 0 6 0 9225 464408576 15694 18446744073709551615 4194304 4365900 140733817144688 18446744073709551615 47998530367074 0 0 4098 83113 18446744073709551615 0 0 17 1 0 0 0\n", 1023) = 244
15:48:54 open("/proc/5269/statm", O_RDONLY) = 10

The only change is in 2 consecutive columns: "2911 502" -> "2912 500".
Is processor usage calculated from those? Can someone explain how?

In reply to Jan Engelhardt:
If I run the endless loop, top just displays 100%.
I've not seen the 9999 in htop, only occasionally "100." for both.

This is on an x86_64 SMP box.
