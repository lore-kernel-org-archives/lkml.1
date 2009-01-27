Return-Path: <linux-kernel-owner+w=401wt.eu-S1754940AbZA0VQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbZA0VQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 16:16:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbZA0VPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 16:15:55 -0500
Received: from smtp-05.arnet.com.ar ([200.45.191.5]:56028 "HELO
	smtp-05.arnet.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753059AbZA0VPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:15:54 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Jan 2009 16:15:53 EST
Message-ID: <497F77F6.40905@lugmen.org.ar>
Date: Tue, 27 Jan 2009 19:09:10 -0200
From: Federico Cuello <fedux@lugmen.org.ar>
User-Agent: Thunderbird 2.0.0.19 (X11/20090101)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Udo Wolter <Udo.Wolter@charite.de>,
       cf@charite.de
Subject: Re: sync-Regression in 2.6.28.2?
References: <20090127093533.GB7037@charite.de>
In-Reply-To: <20090127093533.GB7037@charite.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf Hildebrandt escribió:
> I recently installed 2.6.28.2 on our postfix/dovecot-based
> mailboxserver. Previously, 2.6.28 and 2.6.28.1 have been running there
> without a hitch.
>
> Now with 2.6.28.2 I had two major lockups: All writes to the users'
> Maildirs (on ext4) would stall, the load would rise, "sync" would never
> return.
>
> I had to "reboot -f -n" to get the machine back. All hanging processes
> were unkillable, even with kill -9.
> [...]

The same is happening to me, but I have some logs taken with sysrq.

Here is my vmstat output:

procs -----------memory---------- ---swap-- -----io---- -system--
----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy
id wa
 0  2  99028  46536  26356 1569400    0    0     0     0 1400  437  0
3  0 96
 0  2  99028  46536  26356 1569400    0    0     0     0 1344  355  0
6  0 94
 0  2  99028  46536  26356 1569400    0    0     0     0 1373  387  0
0  0 100
 0  2  99028  46536  26364 1569400    0    0     0    12 1403  384  1
0  0 99
 0  2  99028  46536  26364 1569400    0    0     0     0 1370  378  0
0  0 100
 0  2  99028  46536  26364 1569400    0    0     0     0 1351  346  0
0  0 100
 0  2  99028  46536  26364 1569400    0    0     0     0 1395  412  0
0  0 100
 0  2  99028  46536  26364 1569400    0    0     0     0 1349  332  0
0  0 100
 0  2  99028  46536  26368 1569400    0    0     4     0 1407  387  0
0  0 100

Notice the 100% iowait.

I also managed to reproduce it doing a rsync from one partition to a USB
drive. After the lockup I can't read any file from the source partition,
but the other partitions can be accessed normally.






