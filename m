Return-Path: <linux-kernel-owner+w=401wt.eu-S1755938AbYIRMaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbYIRMaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 08:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbYIRMaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 08:30:09 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:43263 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631AbYIRMaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 08:30:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=heDXKiKmHR3gIM9r6Ag8iEwCIOWHhfccM4cribRF/KiaD407QiFC2g63kPv757b2Zm
         iG5tM3R2aFY+CNBysgCeN23+0NQSOnREtaYs2vnByo7nvTR8VLnbHCRGg6ub1XZXkvSt
         OH1opo/AjC/7PjKLB96f9F3A5lpEWRNqoULhQ=
Message-ID: <48D249D4.8000400@gmail.com>
Date: Thu, 18 Sep 2008 14:30:12 +0200
From: evilsocket <evilsocket@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Stack buffer size issue
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello to all, i'm trying to develop a kernel module that accepts an 
ioctl with this structure :

typedef struct{
    /* [INPUT]  */
    long   process;
    unsigned long address;
   
    /* [OUTPUT] */   
    long mm_size;
}
mg_query_t;

where :

process : is the pid of a process .
address : is the address of a buffer on the stack of that process .

mm_size : *should* be the return value of the ioctl, indicating the size 
of that buffer, as an example (userspace test application):

char * abuffer[123];
mg_query_t query;
   
query.process = getpid();
query.address = abuffer;
   
if( ioctl( fd, IOCTL_MTABLE_BY_PID, &query ) < 0 ){
    close(fd);
    perror( "IOCTL_MTABLE_BY_PID" );
    return -1;
}

printf( "SIZE : %d\n", query.mm_size );



This *should* give the output :

SIZE : 123

I'm using the struct task_struct in the kernel module, looping the mmap 
to find the vm area the address resides in and then to set

mm_size = vm_end - vm_start

But doing so i obtaing only the size of the vm page the buffer resides .

Any hints ?

Thanks in advantage .
