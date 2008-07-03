Return-Path: <linux-kernel-owner+w=401wt.eu-S1756967AbYGCOuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbYGCOuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 10:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbYGCOum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 10:50:42 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:30938 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbYGCOuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 10:50:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Ehu0ygmRhaUG83iYnqboql1eJVp1TFfD4UpvW7MhKxUupuXx0r7LJsDu21lC+85CtN
         YW07pMo0w1UOorbWGlgfNLNmpY2KKp1u2mdGxIeZvVLdUpVqkVxRdRiiYnq+4kYWWhqy
         VPyNOTouAl7+eJWBD3ogLbP6ZR1lDtEi5SCz0=
Message-ID: <19f34abd0807030750n31a3bc3t8609f58c9c1f7c7@mail.gmail.com>
Date: Thu, 3 Jul 2008 16:50:40 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: saravanakumar <saravanakumar.s@teclever.com>
Subject: Re: kernel configuration_ help
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>
In-Reply-To: <1214997772.16081.3.camel@teclever-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214997772.16081.3.camel@teclever-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 2, 2008 at 1:22 PM, saravanakumar
<saravanakumar.s@teclever.com> wrote:
> hai,
> i want my usb to access the root file system,for that what are the
> changes to be done in kernel code, and  in the configuration, i think
> changes to be done in do_mount.c for root delay, if its correct where to
> give the delay.

Hi,

If I understand correctly, you have your root filesystem on a USB
device. It seems that you must pass the rootdelay= option on the
kernel command line. No changes to the code should be necessary.

>From Documentation/kernel-parameters.txt:

        rootdelay=      [KNL] Delay (in seconds) to pause before attempting to
                        mount the root filesystem

Try 10 seconds first, then go lower until it stops working.

It seems that this unfortunate hack is necessary because USB devices
can take an indefinite amount of time to register themselves once
connected.

You will of course also need the relevant config options. Make sure
your filesystem is selected, Advanced partition selection, USB, and
SCSI disk support.

Good luck!


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
