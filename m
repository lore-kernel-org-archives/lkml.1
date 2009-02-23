Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbZBWSWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbZBWSWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 13:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbZBWSWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 13:22:07 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:54479 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbZBWSWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 13:22:04 -0500
Date: Mon, 23 Feb 2009 12:21:53 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Cedric Le Goater <clg@fr.ibm.com>
Cc: Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: debugging threaded apps running under a clone(CLONE_NEWPID)
Message-ID: <20090223182153.GD13151@us.ibm.com>
References: <499EE0D1.1010001@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499EE0D1.1010001@fr.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Cedric Le Goater (clg@fr.ibm.com):
> Hello !
> 
> to debug threaded apps, gdb uses a special libthread_db which seeks in the
> symbols of the exec the list of running threads. This list contains the glibc 
> 'struct pthread' descriptor with pids and tids which values are relative 
> to the namespace in which the threads were created.  
> 
> unless you run gdb in the same pid namespace, gdb will not see any thread
> in the debugged app. this is frustrating for some scenarios and some 
> support from the kernel would be needed to address this issue. Here
> are some ideas :
> 
>    . enter a pid namespace. hard.  
> 
>    . expose the pid numbers of a task in its pid namespaces, through some 
>      ways like /proc/self/stat or /proc/self/pids and modify gdb to make 
>      the conversion.
> 
> How would you do it ? 

perhaps a /proc/$$/vpid which prints out
	task_pid_nr_ns(tsk, current->nsproxy->pidns)
then each thread opens an fd for /proc/self/vpid and passes it
over an af_unix socket to the parent gdb, which then reads it
to get the pid in its own ns?

-serge
