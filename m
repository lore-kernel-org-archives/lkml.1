Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbZEVA77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbZEVA77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 20:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbZEVA7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 20:59:52 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:47861 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbZEVA7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 20:59:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=AvhykHHFzU4vYdsEKR+E3BTOD7JyJvKdbx5HCfXRYF/EKmgJAN8UjTkPd46qE3I5LX
         DIRAn9/qT17YGb4GcsLA6qc0esKvFVrVRkSo70y6Axy6KBvQmuVO9oc6UL5eTSGwduXj
         2Cp9Pk5a1cahujYXeoWvtW5et9VKdcm+GGBl4=
MIME-Version: 1.0
Date: Fri, 22 May 2009 02:59:53 +0200
Message-ID: <c384c5ea0905211759v11408a03o570980a34d02f0ff@mail.gmail.com>
Subject: Rich man's version of AIO on Linux 2.6.x?
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On the state-of-art of asynchronous I/O in Linux. I understand we have
full support for AIO in the Linux 2.6.x kernel but I cannot find how
to use it from user space.


I would like to exploit AIO in hardware and the device driver for it,
by keeping the hardware performing I/O at all times (no setup latency
between requests by allowing multiple
I/O requests to be queued in hardware). Note this is a character
device, not a filesystem.

I implemented aio_read() and aio_write() on my character device
interface, but it's never been called; read() and write() is called
instead.

>From "Understanding the Linux kernel, 3rd edition" I read that glibc
indeed implements aio_read() and friends itself, not through the
kernel AIO syscalls.

<Quote>
Essentially, the aio_read( ) or aio_write( ) library function clones
the current process and lets the child invoke the synchronous read( )
or write( ) system calls; However, this "poor man's" version of the
POSIX functions is significantly slower than a version that uses a
kernel-level implementation of asynchronous I/O.
<End Quote>

I am looking for a rich man's way to use the kernel functionality;
essentially I want my drivers aio_read and aio_write ops to be called.

Regards,
-- 
Leon
