Return-Path: <linux-kernel-owner+w=401wt.eu-S1756023AbZEZQyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbZEZQyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 12:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbZEZQyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 12:54:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45320 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712AbZEZQyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 12:54:02 -0400
Subject: Introducing SELinux sandbox, confining untrusted binaries
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 26 May 2009 12:54:03 -0400
Message-Id: <1243356843.2800.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan and I (mostly Dan) have started to play with using SELinux to
confine random untrusted binaries.  The program is called 'sandbox.'

http://danwalsh.livejournal.com/28545.html

The idea is to allow administrators to lock down tightly untrusted
applications in a sandbox where they can not use the network and
open/create any file that is not handed to the process.  Can be used to
protect a system while allowing it to run some untrusted binary.

A quick dirty example of this sandbox would be to confine the 'cut'
binary.  If I wanted to create a file of users on my system from
the /etc/passwd file, I could try

> sandbox cut -d: -f1 /etc/passwd > /tmp/users
/bin/cut: /etc/passwd: Permission denied

Which shows the sandbox domain is not allowed to open /etc/passwd

But I can execute
> cat /etc/passwd | sandbox cut -d: -f1 > /tmp/users

And it works just fine.

Inside the sandbox cut wasn't allowed to get to /etc/passwd.  But in the
second example since /etc/passwd was opened by the shell and handed to
cut inside the sandbox it works.

I'd love to hear feedback, suggestions, problems, enhancements,
thoughts, complaints, things of that nature!

Check it out, SELinux confinement made easy.

-Eric

