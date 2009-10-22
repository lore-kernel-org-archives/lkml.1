Return-Path: <linux-kernel-owner+w=401wt.eu-S1756134AbZJVNhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbZJVNhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 09:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756114AbZJVNhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 09:37:24 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:61227 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083AbZJVNhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 09:37:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=NPlPFLZ135tSLbdJ9bX+APCs+B6Owrt8FrFuGIxVotzRdIMbqAz2HGd6eEauYibNS6
         upJp1MgXAbpMEOJ8iB+iLgqT4H9CqsMe9mZtMckDr7ViU24S4cL1GO8NIftTCdh3lIDq
         PTLD009+3RvZz3MaIw4CoT/Iz+mRJsTmwmmlg=
MIME-Version: 1.0
Date: Thu, 22 Oct 2009 06:29:39 -0700
Message-ID: <f22d86810910220629o433ee5d0u9857d1fb1f01cd6@mail.gmail.com>
Subject: Process id recycling and status of tasks
From: "Leonidas ." <leonidas137@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

1. What would be an ideal way to check if a task is alive or dead from
kernel space?
I dont want to check current execution state of the task, rather I
want to check whether task
with this pid is existing currently or not?  I might want to do it
periodically, hence even though
a certain pid might exist, it might have got recycled by the time I
check again, right?

Following is an elementary attempt to achieve the same, but I am not
convinced much, and
I am not even sure I can do this kind of thing without knowing the
context I am executing in.

task_t *p;
read_lock(&tasklist_lock);
for_each_process(p) {
 if ( strcmp (p->comm, $your-daemon-name) == 0)
   break;
}
read_unlock(&tasklist_lock);


2. Basically, what would be parameters of a task which will uniquely
identify a task which ever
existed on my machine. Would it be <name, pid> tuple? Or something
else which uniquely
does this job? Basically differentiate N user space threads in a process.

3. What is the algorithm followed for recycling pids? It does not look
very straight fwd like
pick up the latest freed pid for new task etc. I guess the pid
recycling must be starting after
certain threshold.

Any pointers will be helpful.

-Leo.
