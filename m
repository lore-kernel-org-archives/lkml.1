Return-Path: <linux-kernel-owner+w=401wt.eu-S1753206Ab0AKK3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab0AKK3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 05:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154Ab0AKK3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 05:29:17 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:65103 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab0AKK3Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 05:29:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type:content-transfer-encoding;
        b=WJYqWUmNFQIL9wARkLO1TYdek/EznXMp2tIU01ExD2pusU8wM5QAcc9uC/S8YXmaRs
         fRY96doNq4z3bFkFqeeEt3+2M+UoXWr032X4m3q6CQurCfjvjnppDucgmmnC8DzJaDFR
         BRNQ93tt0M9jtKa0G0gGF7Bxz81TuOfO/5l9M=
MIME-Version: 1.0
Date: Mon, 11 Jan 2010 11:29:14 +0100
X-Google-Sender-Auth: 89fffd1524f3b96b
Message-ID: <a57051ba1001110229q2ca28ffbqea37d07735debb52@mail.gmail.com>
Subject: Monitoring file descriptors without switching context
From: Erik Rigtorp <erik@rigtorp.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm working on a low latency soft real time system. We currently run
on Solaris because it has a lower latency TCP stack and less IPC
overhead. I did some experiments with IPC using pipes on Linux. If i
use non-blocking pipes and do a busy reading loop I can achieve
latencies around 1µs. Using blocking pipes or select()/poll()
latencies increase to about 10µs. In general when I use some blocking
system call latencies increase because my process will be put on a
wait queue and the scheduler will do a context switch. However I have
more cores than I have processes/threads  so I don't mind blocking a
whole core to wait for IO, that way I don't incur a full context
switch when the process waits for IO.

What I really need is some way to have the hardware block and monitor
IO for me. Would it be feasible to implement a special low latency
poll() syscall that uses MONITOR/MWAIT instructions to monitor file
descriptors?

I think in order to utilize new multicore CPUs like the Tileras we
need a better signaling mechanism with lower latency than what we
currently have using the scheduler.

Erik Rigtorp
