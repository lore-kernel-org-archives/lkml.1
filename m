Return-Path: <linux-kernel-owner+w=401wt.eu-S1757922AbZBTQ5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922AbZBTQ5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 11:57:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbZBTQ45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 11:56:57 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:59530 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbZBTQ44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 11:56:56 -0500
Message-ID: <499EE0D1.1010001@fr.ibm.com>
Date: Fri, 20 Feb 2009 17:56:49 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Linux Containers <containers@lists.osdl.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: debugging threaded apps running under a clone(CLONE_NEWPID)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello !

to debug threaded apps, gdb uses a special libthread_db which seeks in the
symbols of the exec the list of running threads. This list contains the glibc 
'struct pthread' descriptor with pids and tids which values are relative 
to the namespace in which the threads were created.  

unless you run gdb in the same pid namespace, gdb will not see any thread
in the debugged app. this is frustrating for some scenarios and some 
support from the kernel would be needed to address this issue. Here
are some ideas :

   . enter a pid namespace. hard.  

   . expose the pid numbers of a task in its pid namespaces, through some 
     ways like /proc/self/stat or /proc/self/pids and modify gdb to make 
     the conversion.

How would you do it ? 

Thanks,

C.
