Return-Path: <linux-kernel-owner+w=401wt.eu-S1758397AbXJXMNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397AbXJXMNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 08:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756224AbXJXMNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 08:13:32 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:7908 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139AbXJXMNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 08:13:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=PdBagBSoL+gB1pw4EtpeRaMFnO1fwjgvJ2odFqv7sTvYF2ynS226G3zYjBUKWimQnAzQbyVcUQpnxmOKPnBVAw/ALy0TYaHQaioKGzKIjvDFr8ZQWDBKUlwwKAwlcETpxCisHbqSO7CcAOgATnIm+Wf+mXRP3Ds+B/Bm8bZTx74=
Message-ID: <9d1b82480710240513v269f8075yee754ada43ffca60@mail.gmail.com>
Date: Wed, 24 Oct 2007 17:43:30 +0530
From: Pravin <shindepravin@gmail.com>
To: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov
Subject: userspace Process Classifier based on SELinux Security Contexts for CPUSET, ELSA and Containers
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We are trying to solve the problem that, resource management solutions
like CPUSET and Containers do need manual process classification into
virtual filesystem provided by them as an interface. Also this
classification needs to use PID of a process, so the classification
can be done only after process is created. And this classification is
not persist ant as if process is restarted then PID changes and it
needs to be re-classified again.

To solve above problem we are working on an idea of using SELinux
security contexts as persistent tokens for classification of
processes. Unlike PID of a process, SELinux security context does not
change when process is restarted or machine is rebooted. So, if we can
write rules using on these security contexts, then automatic process
classification can be done entirely from userspace.

We are using connectors for receiving notifications from kernel about
events (ie. fork, exec, id change(uid, gid, suid), exit) in process
management. We check the security context of process using system call
"getpidcon" after system calls like fork and exec. and we use this
security context to classify the process by comparing this security
context against the security-contexts provided by
system-administrators for classification. These rules provided by
system administrators can be used to classify processes in respective
class of CPUSET or containers.
We also provide wild-character support in security context matching.

We are using SELinux security context because they are persistent,
flexible and configurable.
For more reasons,
http://pcss.sourceforge.net/faq.html

Please refer the diagrams at http://pcss.sourceforge.net and
http://pcss.sourceforge.net/pcss_cpuset.html for architecture of the design.

The code for application which will work with CPUSET is hosted on
sourceforge site.
http://pcss.sourceforge.net/pcss-cpuset.tar
This code is not very extensively tested, so there may be some problems with it.

We have also applied similar solution to ELSA (Enhanced Linux System Accounting)
http://elsa.sourceforge.net/

We are also working on using it for classification for containers.
Currently work is
 not yet over for containers.

We are looking forward for some feedback/criticism about the Idea,
architecture of the solution and the code.
We think that it will be helpful in reducing the burden of system
administrators as it uses
all existing infrastructure to provide automatic classification
solutions for different applications which need them.

-- 
Regards,
Pravin Shinde
http://pcss.sourceforge.net
