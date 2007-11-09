Return-Path: <linux-kernel-owner+w=401wt.eu-S1761738AbXKIMgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761738AbXKIMgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 07:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbXKIMgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 07:36:16 -0500
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:36756 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752052AbXKIMgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 07:36:15 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Message-Id;
  b=CqP8o0TZ6G6ELN9qsQCGx1aIQu3mcMpH2GjeHo/EPoJxEVeBvu1LtnioiwAdS6UNshVuLJPFszoJowsloBUv6XMEIbbcV5ymVbQ3l38XdNgmkIbiFrFdtjIFMBXPR7k4apyUXxwcGEz/4khY+Rc2jlyGeRyGO7GHL/Tez30huOo=  ;
X-YMail-OSG: cE8ZcfMVM1lX25OFHWKSTxirfvhDzPsDsn93LQKvI1j4O14zhp9TgYagcKyPLH7cD1nWMFNHOw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: 2.6.24-rc2 slab vs slob tbench numbers
Date: Fri, 9 Nov 2007 23:36:56 +1100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_oRFNHbhxsY3EH1X"
Message-Id: <200711092336.56172.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_oRFNHbhxsY3EH1X
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

Just ran some tbench numbers (from dbench-3.04), on a 2 socket, 8
core x86 system, with 1 NUMA node per socket. With kernel 2.6.24-rc2,
comparing slab vs slub allocators.

I run from 1 to 16 client threads, 5 times each, and restarting
the tbench server between every run. I'm just taking the highest
of each of the 5 tests (because the scheduler placement can
sometimes be poor). It's not completely scientific, but from the
graph you can guess it is relatively stable and seems significant.

Summary: slub is consistently slower. When all CPUs are saturated,
it is around 20% slower. Attached is a graph (x is nrclients, y
is throughput MB/s)

If I can help with reproducing it or testing anything, let me know.
I'll be trying out a few other benchmarks too... anything you want
me to test specifically and I can try.

Thanks,
Nick

--Boundary-00=_oRFNHbhxsY3EH1X
Content-Type: image/png;
  name="slab.png"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="slab.png"

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

--Boundary-00=_oRFNHbhxsY3EH1X--
