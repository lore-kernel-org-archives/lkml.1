Return-Path: <linux-kernel-owner+w=401wt.eu-S1754923AbXEBIZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbXEBIZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 04:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754922AbXEBIZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 04:25:06 -0400
Received: from lon-del-04.spheriq.net ([195.46.50.101]:46488 "EHLO
	lon-del-04.spheriq.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbXEBIZD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 04:25:03 -0400
From: Bhuvan Kumar MITTAL <bhuvan.mittal@st.com>
To: "'Nick Piggin'" <nickpiggin@yahoo.com.au>
Cc: "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>, <linux-kernel@vger.kernel.org>,
       "'Daniel J Blueman'" <daniel.blueman@gmail.com>
Subject: RE: How to make mmap'ed kernel buffer non-cacheable
Date: Wed, 2 May 2007 13:53:08 +0530
Message-ID: <04b101c78c93$1e234ea0$142ec70a@dlh.st.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <46372DDE.2040207@yahoo.com.au>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2962
Thread-Index: AceL6enUtpG7LzVrTd2cCej/l9fBiwAqOVBQ
X-O-Spoofed: Not Scanned
X-O-General-Status: No
X-O-Spam1-Status: Not Scanned
X-O-Spam2-Status: Not Scanned
X-O-URL-Status: Not Scanned
X-O-Virus1-Status: No
X-O-Virus2-Status: Not Scanned
X-O-Virus3-Status: No
X-O-Virus4-Status: No
X-O-Virus5-Status: Not Scanned
X-O-Image-Status: Not Scanned
X-O-Attach-Status: Not Scanned
X-SpheriQ-Ver: 4.2.04
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'll rephrase the problem as follow:

I have a userthread which makes ioctl calls to the kernel and once it reaches inside the kernel it waits on a semaphore. It then does some work inside the kernel and continuously keeps looping between the kernel and user space in an endless while loop. 

I want to kill that thread from another user thread while the former is waiting on a semaphore in kernel (which it will never get) coz I want a clean exit of my driver. Please suggest me a way. I did try the use of pthread_cancel, but that is possible only if the target thread is executing in user space and making use of a pthread_testcancel call (with cancelability enabled ofcourse). 

Kindly suggest something. 

> In continuation to this, I have another query:
> As mentioned above, If there is a kernel task waiting on a semaphore (maybe even in hung state) and I wish to kill the kernel task from user space by making an ioctl call into the kernel, then how is it possible? Is it feasible at all?

If the kernel task is hung because of some bug in your code, then it isn't
really possible in general. You could always just "up" the semaphore and hope,
but things might be corrupted.

If you just want to tell the kernel task to quit, I guess you'd just introduce
some quit ioctl message, and have the kernel thread respond to that.


