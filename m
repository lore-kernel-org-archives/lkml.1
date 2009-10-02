Return-Path: <linux-kernel-owner+w=401wt.eu-S1756311AbZJBM1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbZJBM1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 08:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756166AbZJBM1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 08:27:05 -0400
Received: from mtagate4.de.ibm.com ([195.212.17.164]:37172 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158AbZJBM1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 08:27:03 -0400
Message-ID: <4AC5F198.2070407@fr.ibm.com>
Date: Fri, 02 Oct 2009 14:27:04 +0200
From: Daniel Lezcano <dlezcano@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Pavel Emelianov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
CC: Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: pidns memory leak
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am facing a problem with the pid namespace when I launch the following 
lxc commands:

lxc-execute -n foo sleep 3600 &
ls -al /proc/$(pidof lxc-init)/exe && lxc-stop -n foo

All the processes related to the container are killed, but there is 
still a refcount on the pid_namespace which is never released.
That can be verified in /proc/slabinfo. Running a test suite with 
thousand of tests quickly exhaust the memory and the oom killer is 
triggered.

Reproduced with a 2.6.31 vanilla kernel on i686 and x86_64 architecture.

Thanks
   -- Daniel


