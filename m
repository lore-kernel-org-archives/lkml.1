Return-Path: <linux-kernel-owner+w=401wt.eu-S1752043AbXGLEHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbXGLEHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 00:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbXGLEHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 00:07:01 -0400
Received: from 73.pool85-58-18.dynamic.orange.es ([85.58.18.73]:38413 "EHLO
	cafe.aluzina.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbXGLEHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 00:07:00 -0400
X-Greylist: delayed 1723 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jul 2007 00:07:00 EDT
Message-ID: <4695A225.6050807@aluzina.org>
Date: Thu, 12 Jul 2007 05:38:13 +0200
From: =?ISO-8859-1?Q?Zeus_G=F3mez_Marmolejo?= <zeus@aluzina.org>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: New LSM security operation
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi people,

I've looked around on how to hide inodes in a Linux filesystem but 
surprisingly the kernel lacks this functionality. It would be desirable 
for me to add an ACL to a file in order not to be seen in the directory 
contents but only for some users.

Some Selinux experts point out that the correct way to do this is via 
poly-instantiated directories such as /tmp or /var/tmp, so each user 
"view" his own version of this directory. But that's not what I want, 
for example in /etc, I would want to hide some directories or files for 
some users. I don't want a whole /etc instantiation for each user logged in.

Also, there is a patch called LIDS that does the thing, but patching the 
whole kernel and adding much extra functionality such as intrussion 
detection system as it is. Some rootkits -like adore- also can hide 
inodes, but changing the owner to an uid that the kernel module hides 
from the system call. I don't thing this is a good approach...

For me, the correct way to achieve this is to add an extra op in the 
"security_operations" struct, as an inode operation. With this, a 
Mandatory Access Control system that uses LSM such as SELinux can add 
some policies on the "list" file access vector.

So, I'd call this hook in the vfs_readdir() syscall just after the "file 
<http://lxr.linux.no/ident?i=file>->f_op->readdir()" -the particular 
filesystem readdir()- and walk through the list to ask for each inode if 
it has permission to be "listed" in that directory. Then, the MAC system 
can handle the grant or deny permission per inode, and then return the 
"modified" list to userspace.

I'm not sure if this is the correct way, or maybe it adds to much 
overhead to the "ls" command, but I'd like to hear some opinions, I can 
try to code it and summit a patch...

Thanks for your answer,

Zeus Gómez.
PS. Please, include me in the CC if you reply this message.
