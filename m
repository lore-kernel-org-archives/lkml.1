Return-Path: <linux-kernel-owner+w=401wt.eu-S1753363AbYISOKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbYISOKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 10:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbYISOKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 10:10:12 -0400
Received: from main.gmane.org ([80.91.229.2]:37657 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbYISOKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 10:10:11 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Halesh S <halesh.sadashiv@ap.sony.com>
Subject: Regarding select() on PPC
Date: Fri, 19 Sep 2008 14:04:11 +0000 (UTC)
Message-ID: <loom.20080919T140301-79@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 59.96.48.15 (Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Please find the below testcase.

#include <stdio.h>
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <time.h>
#include <errno.h>
#include <stdlib.h>

int main()
{

 int fd;
 fd_set rfds;
 struct timeval tv;
 int ret_val;

 if ((fd = open("test_file", O_RDWR|O_CREAT, 0664)) < 0)
  {
    printf("Open failed\n");
  }

  FD_ZERO(&rfds);
  FD_SET(fd, &rfds);

  /* Wait up to five seconds. */
  tv.tv_sec = 1;
  tv.tv_usec = 0;

  if ( (ret_val = select(-1, &rfds, NULL, NULL, &tv)) < 0)
  {
    if (errno == EINVAL)
      printf("OK\n");
    else
      printf("Not OK, Got errno %d\n", errno);
  }
  exit(0);
}


For negetive value of n (first argument to select) select fails with
EINVAL error,

But for the same when I tested for PowerPC it was giving EFAULT, 
Its on 2.6.16 kernel.

Please let me know, If this is fixed or it's a issue in PPC.
For other archs its working fine.


Thanks,
Halesh


