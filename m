Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbYIREeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbYIREeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 00:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750854AbYIREeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 00:34:09 -0400
Received: from main.gmane.org ([80.91.229.2]:55016 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbYIREeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 00:34:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Halesh S <halesh.s@india.com>
Subject: execve exit status on MIPS
Date: Thu, 18 Sep 2008 04:33:52 +0000 (UTC)
Message-ID: <loom.20080918T041321-307@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 121.100.32.51 (Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

Please find the below testcase..

#include <stdio.h>
#include <limits.h>
#include <errno.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>

#define EXE_NAME "./exe"

char e2BIG[ARG_MAX+1][10];
char *envList[]={NULL};

int main(void)
{
  int ret,ind;

  for(ind = 0; ind < ARG_MAX+1; ind++)
    strcpy(e2BIG[ind], "helloworld");

  if ((ret = chmod(EXE_NAME,0744)) != 0){
    printf("chmod failed\n");
    exit(1);
  }

  /* whne arg list is too long */
  if ((ret = execve(EXE_NAME,e2BIG,envList)) == -1) {
    if ( errno == E2BIG)
      printf("Test Pass\n");
    else
      printf("Test Fail : Got Errno %d\n", errno);
    exit(0);
  }
  else
    printf("execve worked out of limit\n");
  exit(1);
}


On MIPS E2BIG is not getting set as errno instead EFAULT is set, while on 
other archs like ARM, PowerPC and i686 I am able to get E2BIG.

Please let me know about the issue...

Let EXE_NAME be any executable....

Thanks,
Halesh

