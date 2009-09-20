Return-Path: <linux-kernel-owner+w=401wt.eu-S1750933AbZITELQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750933AbZITELQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 00:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbZITELP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 00:11:15 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:58078 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbZITELP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 00:11:15 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=kmYarY351LcA:10 a=w4iE+TBsmj5y1WloLYF40w==:17
 a=a40KbAr0hy7_PJDnMIsA:9 a=r_i6rhjA1EC6qknwkYJfRzsCyIIA:4
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
To: linux-kernel@vger.kernel.org
Subject: Re: Poor desktop responsiveness with background I/O-operations
Date: Sat, 19 Sep 2009 22:11:17 -0600
User-Agent: KMail/1.12.1 (Linux/2.6.31-git4; KDE/4.3.1; x86_64; ; )
References: <4AB59CBB.8090907@datenparkplatz.de>
In-Reply-To: <4AB59CBB.8090907@datenparkplatz.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200909192211.17381.tfjellstrom@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat September 19 2009, Ulrich Lukas wrote:
> Hi,
> 
> 
> using a recent hard-/software setup, I observed that continuous
> read/write operations severely degrade the overall system responsiveness
> in typical desktop-PC use cases.
> 
> Merely doing write/read operations on a data volume leads to stuck text
> and mouse cursors, seconds-long delays for simple window-context
> switches in X11, dropouts in low-resolution video playback etc.
> 
> 
> 
> Test case:
> - 64-bit dual-core PC, SATA harddrive, plenty of free RAM
> - vanilla Linux 2.6.31, Kubuntu 9.10 packages, all software 64-bit
> 
> 
> How to reproduce:
> - start KDE/GNOME-session
> - open a terminal window and do as a non-root user:
>   dd if=/dev/zero of=/home/john-doe/testfile
>   (or dd if=/home/john-doe/big-testfile of=/dev/null)
> 
> - a real use scenario would be a daily disk-backup or the
>   simple extraction of a tarball containing slightly bigger files
> 
> 
> Observation:
> - The system becomes _really_ slow as described above; unusable for
>   any multimedia tasks.
> 
> - Using an encrypted (dm-crypt/LUKS) /home (e.g. on mobile computers)
>   compounds the issue to a painful extent.
> 
> 
> 
> Possible culprits (I'm guessing) are the Linux I/O- or CPU scheduler.
> 
> I realize that a single heavyweight transfer slows down I/O for the
> corresponding transactions/processes/volumes etc.
> 
> But there needs to be a fair distribution of I/O or CPU time which
> leaves enough for other basic operations. And this doesn't seem to be
> the case with recent Linux versions.
> 
> 
> 
> 
> On a side note, I've tried the BFS-patches (bfs-221 on 2.6.31): This
> yields significantly higher throughput when using disk encryption (50%
> improvement with dm-crypt/LUKS, 512 bit aes-xts-plain cipher mode). But
> with these patches, the responsiveness was even worse during my quick
> test. Switching to a text-mode console: several /minutes/ delay...
> 
> 
> I'm attaching my .config for linux 2.6.31 (grep ^C and bzip2-ed)
> 

I've seen similar things with my Intel p35 (q6600) system, especially under 
64bit. Heavy i/o makes the rest of the system perform very badly. I have 
however not noticed nearly as much of a problem with my AMD (SB700&SB750) 
systems.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
