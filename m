Return-Path: <linux-kernel-owner+w=401wt.eu-S1757493AbXKDE6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493AbXKDE6v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 00:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbXKDE6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 00:58:44 -0400
Received: from [212.12.190.107] ([212.12.190.107]:46772 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752737AbXKDE6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 00:58:43 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-fsdevel@vger.kernel.org
Subject: Massive slowdown when re-querying large nfs dir
Date: Mon, 5 Nov 2007 07:58:38 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711050758.38090.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is a massive (3-18x) slowdown when re-querying a large nfs dir (2k+ 
entries) using a simple ls -l.

On 2.6.23 client and server running userland rpc.nfs.V2:
first  try: time -p ls -l <2k+ entry dir>  in ~2.5sec
more tries: time -p ls -l <2k+ entry dir>  in ~8sec

first  try: time -p ls -l <5k+ entry dir>  in ~9sec
more tries: time -p ls -l <5k+ entry dir>  in ~180sec

On 2.6.23 client and 2.4.31 server running userland rpc.nfs.V2:
first  try: time -p ls -l <2k+ entry dir>  in ~2.5sec
more tries: time -p ls -l <2k+ entry dir>  in ~7sec

first  try: time -p ls -l <5k+ entry dir>  in ~8sec
more tries: time -p ls -l <5k+ entry dir>  in ~43sec

Remounting the nfs-dir on the client resets the problem.

Any ideas?


Thanks!

--
Al

