Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbZLYA6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbZLYA6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 19:58:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbZLYA6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 19:58:38 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:50538 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbZLYA6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 19:58:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=uVhsSOR3z1kCxMetwMIyljJV61fY2pXS9bTS+7GHitAKxpQugA9fthzHWT8QL7lsr0
         4uiLEaNSoUvMfSZL/fg/Cc0nUoXxL6iCGejbNbnD8scthVxXzG3hVsb2eJG5k2uqHChm
         LZtUgj+RC5SZkpSVCJFpYmpVwYnrRb8hwIF+E=
MIME-Version: 1.0
Date: Thu, 24 Dec 2009 18:58:36 -0600
Message-ID: <c9d24a620912241658h6e3bca3eoaccb4d2f1f0b108a@mail.gmail.com>
Subject: Problem in layered block driver using request queues
From: Abhishek <abhishek.rajimwale@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
I am developing a pseudo driver in linux-2.6.13. My pseudo block
driver sits on top of the underlying hard disk driver and exposes a
block device (/dev/mydev). I mount ext3 on this exposed device, run
benchmarks, and monitor the requests.
I am using a request queue in my pseudo device driver and service the
requests in the queue in a while loop like -
while( (req = elv_next_request(queue)) != NULL)
{
XXXXX
}
Here, I am cloning the bios in requests and notifying completion
(after all bios in a request complete) using the documented functions
(end_that_request_* and blkdev_dequeue_request).


THE PROBLEM:
My problem is that for longer benchmarks, the underlying SCSI layer
(in scsi_lib.c) gives error indications like:
-------------------------------------------------------------------------------------------------
Incorrect number of segments after building list
Dec 22 17:33:25 kernel: [ 729.237018] counted 32, received 6
Dec 22 17:33:25 kernel: [ 729.237020] req nr_sec 256, cur_nr_sec 8
.....
------------------------------------------------------------------------------------------------------
After this, my bi_end_io function gets called with bios NOT uptodate
and after a while the system freezes.
Can anybody help me with some useful pointers..

thanks a lot,
Abhishek.
