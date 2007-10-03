Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbXJCOn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbXJCOn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 10:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbXJCOnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 10:43:21 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58988 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603AbXJCOnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 10:43:21 -0400
Date: Wed, 3 Oct 2007 17:43:19 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@kivilampi-30.cs.helsinki.fi
To: Frans Pop <elendil@planet.nl>
cc: LKML <linux-kernel@vger.kernel.org>,
       "Alexander E. Patrakov" <patrakov@ums.usu.ru>
Subject: Re: top displaying 9999% CPU usage
In-Reply-To: <200710031604.07365.elendil@planet.nl>
Message-ID: <Pine.LNX.4.64.0710031731030.27745@kivilampi-30.cs.helsinki.fi>
References: <200710031433.34504.elendil@planet.nl> <4703932C.6060900@ums.usu.ru>
 <200710031604.07365.elendil@planet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Oct 2007, Frans Pop wrote:

> On Wednesday 03 October 2007, you wrote:
> > Try to capture the i/o log with the following command:
> > strace -o top.log top
> 
> Thanks for the suggestion.
> 
> > This will show for sure whether the kernel gives out incorrect data or
> > top misinterprets them.
> 
>  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> 5269 fjp       20   0  442m  61m  33m S 9999  3.1   0:34.12 kontact
> 
> Here are the last two reads for PID 5269 from /proc before that:
> 
> 15:48:51 stat("/proc/5269", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
> 15:48:51 open("/proc/5269/stat", O_RDONLY) = 10
> 15:48:51 read(10, "5269 (kontact) S 1 5100 5100 0 -1 4202560 58186 7891 290 1 2911 502 10 15 20 0 6 0 9225 464408576 15694 18446744073709551615 4194304 4365900 140733817144688 18446744073709551615 47998530367074 0 0 4098 83113 18446744073709551615 0 0 17 1 0 0 0\n", 1023) = 244
> 15:48:51 open("/proc/5269/statm", O_RDONLY) = 10
> 15:48:54 stat("/proc/5269", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
> 15:48:54 open("/proc/5269/stat", O_RDONLY) = 10
> 15:48:54 read(10, "5269 (kontact) S 1 5100 5100 0 -1 4202560 58186 7891 290 1 2912 500 10 15 20 0 6 0 9225 464408576 15694 18446744073709551615 4194304 4365900 140733817144688 18446744073709551615 47998530367074 0 0 4098 83113 18446744073709551615 0 0 17 1 0 0 0\n", 1023) = 244
> 15:48:54 open("/proc/5269/statm", O_RDONLY) = 10
> 
> The only change is in 2 consecutive columns: "2911 502" -> "2912 500".
> Is processor usage calculated from those? Can someone explain how?

The latter seems to be utime ...decreasing. No wonder if arithmetics will 
give strange results (probably top is using unsigned delta?)...


-- 
 i.
