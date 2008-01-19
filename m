Return-Path: <linux-kernel-owner+w=401wt.eu-S1760304AbYASOae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760304AbYASOae (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 09:30:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbYASOa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 09:30:26 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:47388 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543AbYASOa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 09:30:26 -0500
Date: Sat, 19 Jan 2008 15:30:24 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Rafael Sisto <rafael.sisto@gmail.com>
cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: new file in kernel.
In-Reply-To: <ee3dc96c0801190608q33aee0aer133611a1fc392bb4@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0801191526200.27831@fbirervta.pbzchgretzou.qr>
References: <ee3dc96c0801190542u2f91a2eax3bcfd0268d4850b4@mail.gmail.com> 
 <Pine.LNX.4.64.0801191448140.27831@fbirervta.pbzchgretzou.qr>
 <ee3dc96c0801190608q33aee0aer133611a1fc392bb4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 19 2008 11:08, Rafael Sisto wrote:
>
>I had already read that webpage, but I dont need to change the data on
>that file. I just want to create a new file and then close it, so I
>can use it later in another system call, to mmap it to a user space.
>Is it clearer now?
>Can you please give me some code snippet?

I don't get what your indirection is supposed to do.

 userspace -> sys_open -> kernel space -> create file
           -> sys_close -> kernel space -> close it

vs

 userspace -> sys_mycall -> kernelspace -> sys_open -> create_file
                                        -> sys_close -> create_file

As for code snippets:

asmlinkage logn sys_mycall(const char __user *filename,
    unsigned int flags, unsigned int mode)
{
	long ret;

	ret = sys_open(filename, flags, mode);
	if (ret < 0)
		return ret;

	return sys_close(fd);
}

You see, this is currently just too trivial to make sense, but if
it helps you, no problem.

>Sorry for the last mail, I answered to your personal mail only)

Here, we use Reply-to-all.

