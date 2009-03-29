Return-Path: <linux-kernel-owner+w=401wt.eu-S1762074AbZCaGE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762074AbZCaGE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 02:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758200AbZCaGEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 02:04:44 -0400
Received: from france.micfo.com ([92.48.68.3]:50856 "EHLO france.micfo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625AbZCaGEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 02:04:43 -0400
X-Greylist: delayed 153615 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Mar 2009 02:04:43 EDT
From: Alberto Gonzalez <info@gnebu.es>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Ext4 and the "30 second window of death"
Date: Sun, 29 Mar 2009 12:24:21 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.28-ARCH; KDE/4.2.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903291224.21380.info@gnebu.es>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - france.micfo.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - gnebu.es
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Reading this discussion about the fsync performance problems, the reliability 
of delayed allocation, etc... made me a bit confused, so as a normal user I 
would like to ask a clear question with an example so I can get a clear answer 
and understand the implications of all this.

- Let's say I'm a writer and I like to take my laptop to a cafe every day to 
write there for a few hours.

- As such, I want to get good battery life so I'm fine with my data being 
written to death say every 30 seconds instead of waking up the disk 
immediately if I save the document I'm working on.

- I use Ext4 as my filesystem (default in next Fedora release).

- Let's say I've been working on my book for the last 14 months and I've 
written about 400 pages on an ODF file.

- My usual workflow is that every time I finish a paragraph, say every 2-3 
minutes, I hit Ctrl+S to save the changes.

- So one day, while I'm working on the book the following happens: I finish a 
paragraph and his Ctrl+S to save it. 5 seconds later the system freezes for 
some reason. Let's suppose that in that 5 window timeframe between pressing 
Ctrl+S and the crash the data has not been written to disk (which happens 
every 30 seconds). So as a result I:

A - Lose that last paragraph
B - Lose the whole book

If it's 'A', then that's ok, as expected. Bad luck. But if it's 'B', then I 
think that's totally unexpected by any user, and totally unacceptable too. 
Sure I want good performance and good battery life, but not at such cost. 
(Yes, you can argue I should have a recent backup at home, and you'd be right, 
but that doesn't change things fundamentally).

As far as I understand, with Ext3 (defaults), the behavior was A. Will this 
change to B with Ext4 and all "modern" filesystems (XFS, Btrfs,...)?

Thanks for any answer.
