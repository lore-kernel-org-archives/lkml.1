Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbXCRIIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbXCRIIp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 04:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbXCRIIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 04:08:45 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:3925 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbXCRIIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 04:08:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=tqgGTv9rurJvVIbK+hYiogu5ckh8vrO/H019v8/wPxWfdK8lqbj81o+vNVo9DcrS7RwYwDXy4sOl0zomqwvUSJ7EwRor4rcDcg+U8TCmOtQ16pJEfYFLPgbhL6PEePZKlQiUnKPZm2XLC4iOUwWy1F56XB8x3QBOAn38U5N4kbQ=
Message-ID: <b965e8580703180108t6bc50b0eg895c5464463ab09@mail.gmail.com>
Date: Sun, 18 Mar 2007 16:08:43 +0800
From: "Ying Chu" <xjtuychu@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: sysenter cause a segmentation fault.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: f602dd49422e4115
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A simple code running on PIII 800,kernel 2.6.20 with SEP enabled
causes  a  segmentation fault.
The slice is as following.

#include <stdio.h>
#include <sys/syacall.h>

int main()
{
    unsigned long ret=0;
    __asm__ __volatile__ ("movl %1,%%eax\n\tpushl %%ecx\n\t"
     "pushl %%edx\n\tpush %%ebp\n\t"
     "movl %%esp,%%ebp\n\t"     "sysenter\n\t"
     "movl %%eax,%0"
     :"=m"(ret)
     :"b"(SYS_getuid));
   printf("%d\n",ret);
   return 0;
}

More, when i enabled Kdb and set "bp sysenter_entry",it went with a
catastrophic error errupted.
