Return-Path: <linux-kernel-owner+w=401wt.eu-S965967AbXDIVnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965967AbXDIVnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932081AbXDIVnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:43:18 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37517 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074AbXDIVnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:43:12 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <461AB361.5050207@s5r6.in-berlin.de>
Date: Mon, 09 Apr 2007 23:42:57 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: <linux/wait.h> uses definitions from <linux/sched.h> (was Re: 2.6.21-rc6-mm1)
References: <20070408143559.f5014629.akpm@linux-foundation.org> <64bb37e0704091203m7cb4adc9g1bf6bf179603cf4a@mail.gmail.com>
In-Reply-To: <64bb37e0704091203m7cb4adc9g1bf6bf179603cf4a@mail.gmail.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Torsten Kaiser wrote:
> drivers/ieee1394/ieee1394_transactions.c fails for me if CONFIG_SMP=n
> 
> gcc complains:
>  CC      drivers/ieee1394/ieee1394_transactions.o
> drivers/ieee1394/ieee1394_transactions.c: In function 'hpsb_get_tlabel':
> drivers/ieee1394/ieee1394_transactions.c:183: error:
> 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
[...]
> I fixed this by adding #include <linux/sched.h> before #include
> <linux/wait.h>
> But that is probably not the correct fix, but gives me a working kernel.

Thanks, I'll add this to linux1394-2.6.git (which exposed the problem)
ASAP.  On the other hand, the culprit is actually include/linux/wait.h
which IMO should include the headers it needs for itself.
-- 
Stefan Richter
-=====-=-=== -=-- -=--=
http://arcgraph.de/sr/
