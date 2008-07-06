Return-Path: <linux-kernel-owner+w=401wt.eu-S1758421AbYGFUH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421AbYGFUH2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 16:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755138AbYGFUHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 16:07:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:64904 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbYGFUHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 16:07:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=b8WZneot6VQWFqqMPvuWyG3c8X3ja/jObxkiqtKkiaJ7f/kE4E3bAsoqt2w1ohDAxK
         2Nlp6FZ5JKnFPtyzh4fozDeVfzE1d4GYEi6EG1VnUXR96rXQwQshencS7MHqNSlVYXvx
         wv5NS8S1d8xB4YTRT3VpkQ8HgQaB5lxIP6EiE=
Message-ID: <9871ee5f0807061307ncc55104y477c57be3e91b75f@mail.gmail.com>
Date: Sun, 6 Jul 2008 16:07:14 -0400
From: "Timothy Normand Miller" <theosib@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: HELP: Getting unexpected fakeraid behavior. Fix?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I apologize if this is a question that has come up a lot.  I've done a
fair amount of googling on it, and while I've learned a lot, I have
not been able to find an answer to my specific question.

I'm running a beta of Gentoo 2008.0, ~amd64, kernel version
2.6.25-gentoo-r5 (Gentoo's 'genkernel').  The drive controller I'm
using is built into the Intel ICH9R southbridge.  I used the Intel
Matrix BIOS tool to configure two SATA-II drives in a RAID1
configuration.

My understanding of fakeraid/dmraid is as follows:
- There is no real RAID controller, just a regular drive controller chip.
- The only difference is that there's some BIOS code that allows the
system BIOS use the array as a boot device.
- Once the kernel comes up, it's completely in control of the
individual drives, I/O scheduling, etc. (They look like regular SATA
devices.)
- So since fakeraid, as far as Linux is concerned, is just software
RAID, behavior and performance of fakeraid (dm) and software RAID (md)
should be identical (via the same drive controller).

Since RAID1 is a mirrored configuration, it's possible to distribute
reads across the drives, improving throughput and latency over a
single drive on random reads.  I have also come to understand that
RAID1 systems in general and Linux specifically do in fact take
advantage of this mirroring to improve read performance.

I have written a program that, on start up, reads through thousands of
small files, and as a result does a great deal of random reads for
several minutes.  While that was going on, I ran "iostat -d 2".  My
observation was that any writes that occurred were correctly sent to
both disks, but all reads were being requested ONLY from the first
drive.

This suggests to me that I have some configuration mistake.  Can
anyone give me any hints on this?

Thanks!

-- 
Timothy Normand Miller
http://www.cse.ohio-state.edu/~millerti
Open Graphics Project
