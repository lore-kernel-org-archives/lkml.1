Return-Path: <linux-kernel-owner+w=401wt.eu-S1752132AbYJ0O3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbYJ0O3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 10:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbYJ0O3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 10:29:34 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:46871 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbYJ0O3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 10:29:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:content-type
         :content-transfer-encoding:message-id;
        b=rq7aPhUyhsz2JUSATrLPhzPRnF8s24SYyu6TnPw/yoLomfdfSv5dda4Kai9C/5JZbU
         TLBA/3VroAxIs5BesVict/iXBp/lSmT2c7ZfZKe4oVLd0RmmN59Q+VigS2ZnBx6LHXkZ
         LrfK8DkobocRmwIPFHEOXrXc/6d4tgXVBqJpo=
From: Eric Lacombe <goretux@gmail.com>
To: Avi Kivity <avi@redhat.com>
Subject: Re: [x86] - technical questions about HV implementation on Intel VT
Date: Mon, 27 Oct 2008 15:29:26 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200810201927.33580.goretux@gmail.com> <48FD9B54.4040109@redhat.com>
In-Reply-To: <48FD9B54.4040109@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200810271529.26821.goretux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for your answer.
I will eventually add a netconsole, but for now, I find how to bypass my 
problem (getting debug information).

However I come with a new question, related to an unexpected VM-exit.
The scenario is as follows:
1. some setup occur
2. vmlaunch is executed by a function F, so the guest is launched. This guest 
(as I explained in my previous mail) executes the end of the function F.
3. The end of F, do some "printk" then return to the module init function.

The problem is that I get a VM-exit during the step 3. In fact after the 
first "printk", a vm-exit occurs with exit_reason=2 (triple-fault).

Do you have an idea of what could be the cause of this vm-exit?

Note:
- If I do no "printk" at the end of F, then F returns without any problems to 
the caller, and when this caller do a "printk" the vm-exit occurs (I can see 
the result of "printk" on the screen).
- I also tried to insert 2 "printk" and a "panic" at the end of F. result: 
the "panic" is never reached. (so the vm-exit occurs after the first "printk" 
has done his job).

Thanks in advance for your answer,

	Eric

On Tuesday 21 October 2008 11:05:24 Avi Kivity wrote:
> Eric Lacombe wrote:
> > [...]
> > So, when the host take control for the first time after the first vmexit,
> > I would like the host to print informations and to "die correctly", so as
> > I could read these information on the screen (ie, without being polluted
> > with lots of debug messages that scroll on the screen).
>
> You should add a serial console or netconsole to your hypervisor; that
> means implementing a serial or network card driver.


