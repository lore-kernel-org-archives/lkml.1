Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbXDSWmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbXDSWmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 18:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbXDSWmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 18:42:39 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:59924 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbXDSWmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 18:42:38 -0400
Message-ID: <03f401c782d4$95c323e0$eeeea8c0@aldipc>
From: "roland" <devzero@web.de>
To: <linux-kernel@vger.kernel.org>
Subject: VMWare Workstation 6 for debugging Linux Kernel (!)
Date: Fri, 20 Apr 2007 00:46:34 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.2869
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2869
X-Provags-ID: V01U2FsdGVkX1/vep1rEH9xBxHWnW+1B/B3gbWpVqpE7khTyf6p
	X7lXspwanSZt0lfNoEt8yozPiYX3V7KxkA5afJjJiofTys+8ar
	gIoW8wEUM=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

I think this one is damn interestig for linux kernel development:

link: http://stackframe.blogspot.com/
contents: see below

regards
roland

ps:
i`m not directly related to vmware - so this is no advertisement!


Tuesday, April 17, 2007
Debugging Linux kernels with Workstation 6.0
We just quietly added an exciting feature to Workstation 6.0. I believe it 
will make WS6 a great tool for Linux kernel development. You can now debug 
kernel of Linux VM with gdb running on the Host without changing anything in 
the Guest VM. No kdb, no recompiling and no need for second machine. All you 
need is a single line in VM's configuration file.

To use the new feature, grab the latest build of WS6 here:

http://www.vmware.com/products/beta/ws/

Put this line into configuration file of your Linux VM:

debugStub.listen.guest32=1

Now whenever you run the virtual machine, you'll see the following on the 
Host console:

VMware Workstation is listening for debug connection on port 8832.

Run gdb on the Host, reference it to the kernel with symbols and attach to 
the virtual machine:

% gdb
(gdb) file vmlinux-2.4.21-27.EL.debug
(gdb) target remote localhost:8832

That's it. The VM is blocked now, so you can "continue" it and "^C" back to 
gdb. Breakpoints, single step, memory inspection - all this works as usual. 
If you have SMP VM, then each VCPU is mapped on a thread, so use "info 
threads" and "thread NN" to switch between them.

The kernels with symbols are sadly lacking on most distributions, but if you 
use RHEL then this website may help (look for kernel-debuginfo rpm):

http://people.redhat.com/duffy/debuginfo/index-js.html

The gdb support in WS6 is experimental, so there may be rough edges here and 
there. Please post on community forums if something doesn't work right or if 
you have a suggestion:

http://www.vmware.com/community/

There are more debugging specific features in WS6 (for example, you can use 
gdb hand-in-hand with Record/Replay!). I will describe them shortly.




