Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbZJSI6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbZJSI6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 04:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755899AbZJSI6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 04:58:10 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:59593 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732AbZJSI6J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 04:58:09 -0400
X-AuditID: b753bd60-ab846ba000006009-3e-4adc2a246aa8
Message-ID: <4ADC2A1D.2090303@hitachi.com>
Date: Mon, 19 Oct 2009 17:58:05 +0900
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, davem@davemloft.net,
       satoshi.oshima.fk@hitachi.com, hidehiro.kawai.ez@hitachi.com,
       hideo.aoki.tk@hitachi.com, masanori.yoshida.tv@hitachi.com
Subject: Re: [PATCH] AF_UNIX: Fix deadlock on connecting to shutdown socket
References: <4ADC010C.5070809@hitachi.com> <2375c9f90910190002m372edafq9a4c95d754640487@mail.gmail.com>
In-Reply-To: <2375c9f90910190002m372edafq9a4c95d754640487@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-MIME-Autoconverted: from 8bit to quoted-printable by sdl99w.sdl.hitachi.co.jp id n9J8w5Wx031180
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, thanks for testing!

Américo Wang wrote:
> On Mon, Oct 19, 2009 at 2:02 PM, Tomoki Sekiyama
> <tomoki.sekiyama.qu@hitachi.com> wrote:
>> Hi,
>> I found a deadlock bug in UNIX domain socket, which makes able to DoS
>> attack against the local machine by non-root users.
>>
>> How to reproduce:
>> 1. Make a listening AF_UNIX/SOCK_STREAM socket with an abstruct
>>    namespace(*), and shutdown(2) it.
>>  2. Repeat connect(2)ing to the listening socket from the other sockets
>>    until the connection backlog is full-filled.
>>  3. connect(2) takes the CPU forever. If every core is taken, the
>>    system hangs.
>>
>> PoC code: (Run as many times as cores on SMP machines.)

Sorry for my ambiguous explanation ...

> Interesting...
> 
> I tried this with the following command:
> 
> % for i in `seq 1 $(grep processor -c /proc/cpuinfo)`;
> do ./unix-socket-dos-exploit; echo "=====$i====";done
<snip>
> My system doesn't hang at all.
> 
> Am I missing something?
>
> Thanks!

You should run the ./unix-socket-dos-exploit concurrently, like below:

for i in {1..4} ; do ./unix-socket-dos-exploit & done

# For safety reason, the PoC code stops in 15 seconds by alarm(15).

-- 
Tomoki Sekiyama
Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: tomoki.sekiyama.qu@hitachi.com

