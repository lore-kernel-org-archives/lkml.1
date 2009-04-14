Return-Path: <linux-kernel-owner+w=401wt.eu-S1752565AbZDNKWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbZDNKWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 06:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbZDNKWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 06:22:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:39868 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750746AbZDNKWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 06:22:41 -0400
X-Authenticated: #3373616
X-Provags-ID: V01U2FsdGVkX1+Vkrdo2lOV6n6ZO6CutbSeA3Ogag9/Iuc40TZoVU
	hL/Gfv4Oyl7t3T
Message-ID: <49E463EA.7070407@gmx.de>
Date: Tue, 14 Apr 2009 12:22:34 +0200
From: =?ISO-8859-15?Q?Simon_K=E4mpflein?= <s.kaempflein@gmx.de>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Question: IO priorities for disk writes?
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

is there a possibility to prioritize disk writes? I tried ionice with
cfq scheduler, but as far as I understand and tested it only works for
reading.

Background:
I have one block device (SATA drive) and a data stream of about 6 MB/s
written by a process to files on the device (fs: reiserfs, fp opened
with O_DIRECT). The data is generated externally and processed and
buffered in memory by the process. So an average bandwidth of 6 MB/s for
writing is required. Another process reads the data in parallel, also
with about 6 MB/s.

So generally this is no problem when the system has nothing else to do.
But when other heavy disk writes occur, e.g. data written to the disk
via network (another extreme case: dd if=/dev/zero of=tmpfile), the
writing speed drops far below 6 MB/s.

So far I tried with no luck (io scheduler cfq):
- "ionice -c0 -n0" for the writer and reader
- "ionice -c3" for all pdflush threads

Is there any possibility to get this working with the current kernel
version? The performance of the other processes besides the
reader/writer is unimportant. Alternatively I'm thinking about using a
second block device for the writing/reading (maybe an USB-Stick?).

Best regards,
Simon

