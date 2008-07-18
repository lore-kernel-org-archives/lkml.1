Return-Path: <linux-kernel-owner+w=401wt.eu-S1758623AbYGRSvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623AbYGRSvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 14:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755766AbYGRSva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 14:51:30 -0400
Received: from merle.it.northwestern.edu ([129.105.16.57]:33092 "EHLO
	merle.it.northwestern.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644AbYGRSv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 14:51:29 -0400
X-Greylist: delayed 1525 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jul 2008 14:51:29 EDT
From: "d gitelman" <d-gitelman@northwestern.edu>
To: <linux-kernel@vger.kernel.org>
Subject: kernel 2.6.18-92.1.6 produces errors when using nfs and nis
Date: Fri, 18 Jul 2008 13:25:59 -0500
Message-ID: <6B207F14C1A94D46B5903DB7623657B5@nmff.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
thread-index: AcjpA7nEkK5b+t4ASf+Ug5FhWT6mUA==
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

The following errors occur when I use kernel 2.6.18-92.1.6.el5  but not with
kernel 2.6.18-53.1.21.el5, with no change to any conf files when I switch
kernels.  I am running RHEL 5.

I am a newbie and apologize in advance if this is the wrong place to ask
this question or if this message contains inadequate information. Please
advise.

The problem is that when the nfs service starts I get the following error
message on my nis clients (again this is only with kernel 2.6.18-92.1.6 and
not 2.6.18-53.1.21)
 
[root@chinook init.d]# service nfs start
Starting NFS services:                                     [  OK  ]
Starting NFS quotas: yp_all: clnt_call: RPC: Timed out
yp_all: clnt_call: RPC: Timed out
yp_all: clnt_call: RPC: Timed out
yp_all: clnt_call: RPC: Timed out
yp_all: clnt_call: RPC: Timed out
yp_all: clnt_call: RPC: Timed out
yp_all: clnt_call: RPC: Timed out
yp_all: clnt_call: RPC: Timed out
                                                           [  OK  ]
Starting NFS daemon:                                       [  OK  ]
Starting NFS mountd: yp_all: clnt_call: RPC: Timed out
yp_all: clnt_call: RPC: Timed out
yp_all: clnt_call: RPC: Timed out
yp_all: clnt_call: RPC: Timed out
yp_all: clnt_call: RPC: Timed out
yp_all: clnt_call: RPC: Timed out
                                                           [  OK  ]

 
This occurs when the system is booting or if I stop and then start the
service. 
 
No messages relevant to this error appear in /var/log/messages 
 
No matter which kernel starts yp is appropriately bound to the NIS server
ypwhich returns the name of the server and ypcat passwd returns the
passwords.
 
RPC appears to be running correctly
 
[root@chinook ~]# rpcinfo -p localhost
   program vers proto   port
    100000    2   tcp    111  portmapper
    100000    2   udp    111  portmapper
    100007    2   udp    966  ypbind
    100007    1   udp    966  ypbind
    100007    2   tcp    969  ypbind
    100007    1   tcp    969  ypbind
    100024    1   udp    644  status
    100024    1   tcp    652  status
    100021    1   udp  32784  nlockmgr
    100021    3   udp  32784  nlockmgr
    100021    4   udp  32784  nlockmgr
    100021    1   tcp  43375  nlockmgr
    100021    3   tcp  43375  nlockmgr
    100021    4   tcp  43375  nlockmgr
    100011    1   udp    766  rquotad
    100011    2   udp    766  rquotad
    100011    1   tcp    790  rquotad
    100011    2   tcp    790  rquotad
    100003    2   udp   2049  nfs
    100003    3   udp   2049  nfs
    100003    4   udp   2049  nfs
    100003    2   tcp   2049  nfs
    100003    3   tcp   2049  nfs
    100003    4   tcp   2049  nfs
    100005    1   udp    804  mountd
 
[root@chinook ~]# rpcinfo -u localhost ypbind
program 100007 version 1 ready and waiting
program 100007 version 2 ready and waiting

ypdomainname, nisdomainname, hostname all return appropriate values, which
are not different between kernels.
 
Searching google returned a suggestion to change the file limits > ulimit -n
256, but this does not resolve the error.
 
I am running the following versions of programs (of course these do not
change when switching kernels)
ypbind-1.19-8.el5
yp-tools-2.9-0.1
nfs-utils-1.0.9-33.el5
nfs-utils-lib-1.0.8-7.2.z2
nfs4-acl-tools-0.3.1-1.el5.1


Please CC me on any replies.
Any help would be greatly appreciated. This is driving me crazy.
 
Darren


