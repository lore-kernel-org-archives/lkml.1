Return-Path: <linux-kernel-owner+w=401wt.eu-S1752732AbYJ1Gnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbYJ1Gnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 02:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbYJ1Gnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 02:43:35 -0400
Received: from main.gmane.org ([80.91.229.2]:37303 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776AbYJ1Gnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 02:43:35 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Halesh S <halesh.s@india.com>
Subject: parent process behaviour to signal after vfork()
Date: Tue, 28 Oct 2008 06:43:19 +0000 (UTC)
Message-ID: <loom.20081028T062822-852@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 59.96.48.15 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.3) Gecko/2008092417 Firefox/3.0.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please find the below test code...

#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>
int x = 0;
typedef void (*sighandler_t)(int);
void fun()
{
  printf("SIGNAL CAUGHT\n");
}

int main()
{
  int pid;

  signal(SIGINT, (sighandler_t)fun);
  signal(SIGSEGV, (sighandler_t)fun);
  pid = vfork();

  if ( pid == 0 ) {
    printf(" I am child - %d \n", pid);
    x++;
    raise(SIGINT);
    printf("x = %d\n", x);
    exit(0);
  }
  else {
    printf(" I am parent - %d\n", pid);
    raise(SIGSEGV);
    printf("x = %d\n", x);
  }
}

Why the parent process is not able to handle/respond the signals, when a child
once handles the signal, child is created using vfork(). 

In vfork() man page - 
       "Signals to the parent arrive after the child releases the parent's 
       memory."

How to make sure that child has released the parent memory..??

Thanks,
Halesh










