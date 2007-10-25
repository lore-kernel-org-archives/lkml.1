Return-Path: <linux-kernel-owner+w=401wt.eu-S1757870AbXJYGFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbXJYGFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 02:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbXJYGFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 02:05:38 -0400
Received: from mail.bmlv.gv.at ([193.171.152.37]:55524 "EHLO mail.bmlv.gv.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbXJYGFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 02:05:37 -0400
From: "Ph. Marek" <philipp.marek@bmlv.gv.at>
To: linux-kernel@vger.kernel.org
Subject: Exporting a lot of data to other processes?
Date: Thu, 25 Oct 2007 08:05:33 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710250805.33369.philipp.marek@bmlv.gv.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody,

I've already pondered about a question for some time, and would like to ask 
for a better idea here. It's not entirely about the kernel - although that 
surely has some impact, too.


I've got some process/daemon, that wants to export information to other 
processes. As model for exporting that data I found the sysfs and procfs 
nice - an easy "cat" can give you the needed data.

Now, in order to do something like that from userspace, I either have to:

-) use FUSE
   - feels slow (many context switches)
   - much overhead for such common things (another daemon)
-) use named pipes in some directory structure, and keep them open in
   the daemon - waiting to be written to
   - many open filehandles
   - feels not really useable for bigger (>1000) structures
-) use some ramfs/shmfs or similar, and overwrite the data occasionally
   - not current data
   - runtime overhead (processor load)

Now the open/close events wouldn't be interesting; the read() and (possibly) 
write events would have to be relayed (which is not the case for FUSE, IIUC)

Is there some better way? For small structures the pipes seem to be the best 
way ... just wait for a reader, give it data, and finished.


Thank you for all ideas.


Regards,

Phil
