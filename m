Return-Path: <linux-kernel-owner+w=401wt.eu-S1761719AbYASFRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761719AbYASFRz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 00:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbYASFRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 00:17:48 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:24484 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbYASFRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 00:17:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dqebeOdzw2HzJCJtOaZrq2cg2HbxHCrliiwiiGt/CTg8xCawYqSnChYFFstSqdkEidzUCcron8W+PpYXD7GyhcC1AajF0w+SDw8WmwPWsKtUonNjPMhMLvIsMuFk/bLkZzwEF05miEp3ujdJttBGJ8kKskfl0JWJqyC0nLho27Y=
Message-ID: <ee3dc96c0801182117t6e40b46fr1b2d5826e22a7124@mail.gmail.com>
Date: Sat, 19 Jan 2008 02:17:46 -0300
From: "Rafael Sisto" <rafael.sisto@gmail.com>
To: "Linux kernel" <linux-kernel@vger.kernel.org>
Subject: create a file in kernel mode. help please!
In-Reply-To: <ee3dc96c0801182116q3d54148dl6773d76ff3160d91@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ee3dc96c0801182116q3d54148dl6773d76ff3160d91@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,
obviously this is a newbie question, but I couldn't find any
documentation on how to do it.. I tried several ways but couldnt do
it.
I designed a system call, so a user will call it, and a new file will
be created ('/tmp/filexx'). After that, I have another system call,
that will map the file into the maps of the user process. The idea is
the same as IPC...

I managed to create the file with this function (in the first system call):
        fd = filp_open(path, O_CREAT | O_RDWR , 777);

After that, the user will call another system call, and it will map
this file to the process maps.
something like this:
         filp_open(route, O_RDWR,0 );
         do_mmap(fp, 0, tamano, PROT_READ | PROT_WRITE | PROT_EXEC,
MAP_SHARED, 0);

After I call the second system call, the user tries to access the
memory, but gets the message "Bus Error".
I tried to manually create a file with vi, and then use the second
system call, and worked perfectly. I could use the shared memory
without problems.

The problems seems to be in the first system call (with filp_open),
when I try to create a new file... Can somebody suggest me something,
on how I could fix this issue?? It is very important because it is for
a college projects.

Greetings, and thanks in advance for the answers.
Rafael Sisto - Uruguay.-
