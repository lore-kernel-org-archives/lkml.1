Return-Path: <linux-kernel-owner+w=401wt.eu-S1759869AbYFSNJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759869AbYFSNJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 09:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758201AbYFSNJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 09:09:12 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:60735 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987AbYFSNJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 09:09:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EjYzOrpLSCmRkTZl+Vo+tdoi3IJjolKvsrVzX8ywcHgzW/7uhrJClAZJvaLCk1rsFg
         /UXrBZgi2OO8uwewkkrnzCb9++TvZUIZxJmN0Cal1L050sA2V+RW/SBATyQEcvrNyvYr
         DX5Add9E8xPBBtkeRP6X9X2at/5x1bz48unW0=
Message-ID: <94a8a9170806190609v4ad0049dva37c9712f3d928a1@mail.gmail.com>
Date: Thu, 19 Jun 2008 18:39:10 +0530
From: "Madhu R" <tuxmadhu@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: KLOGD loops continuously calling 'syslog' system call when prink is disabled
In-Reply-To: <94a8a9170806190606r626bc57aq77c46586af97ea05@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <94a8a9170806190531j7404c96ei4bee3cf5774cbe5a@mail.gmail.com>
	 <94a8a9170806190559x3d253006ic009b9c4b6714e5b@mail.gmail.com>
	 <94a8a9170806190606r626bc57aq77c46586af97ea05@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

         when I disable printk(CONFIG_PRINTK=n) in the kernel config
(2.6.26-rc6),  the klogd  loops continuously calling the 'syslog'
system call. It consumes 99% of the cpu time ( using 'top' command ) .
I found similar problem in the kernel mailing list and a patch had
gone into the mainline kernel
http://linux.derkeiler.com/Mailing-Lists/Kernel/2006-11/msg03317.html

         In the patch, it returns 'ENOSYS'' while calling 'syslog'
system call if printk is disabled. So the klogd keeps on calling this
'syslog' and returns ENOSYS and this process takes most of the CPU
time.


         Please clarify whether I am following correct procedure or
this is DEFAULT behavior of klogd.


Thanks,
madhu.
