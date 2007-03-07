Return-Path: <linux-kernel-owner+w=401wt.eu-S1750874AbXCGFbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750874AbXCGFbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 00:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbXCGFbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 00:31:39 -0500
Received: from wr-out-0506.google.com ([64.233.184.230]:5006 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbXCGFbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 00:31:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=t/iPnUqyqAdkC8RmJ2xro3cvViSvPkHnMqtsdqkSEWlAat52IIQjrT0Mo3FPxPm3xipT6sjwg6ZfGYNMRmJBh2qDUiF0rdyDZy+7JGUnWO90dxhHJtKXYy+cbyomo6mUx266CbI714/Q/Hxsflephjh4iP0gCXhSNmQbTYzr7Xo=
Message-ID: <1b2aacd80703062131g6c8578fgf200dd05a502c49f@mail.gmail.com>
Date: Tue, 6 Mar 2007 21:31:37 -0800
From: "Luong Ngo" <luong.ngo@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Sleeping thread not receive signal until it wakes up
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am having this problem. I have a process with 2 threads created. One
of the thread will keep calling IOCTL  to get information from the
kernel and will be blocked if there is no new information. If there is
information retured, the thread will be checked to see if any error
happens and trigger an action. Since we have no way to know if the
error is gone (Hardware provides no signal), so what we do is when
trigger an action for the error, we will set an timer using alarm()
and register a SIGALRM handler in the thread by using sigaction. After
setting the alarm, the thread will loop back and call IOCTL, which
could cause it to be put to sleep. The problem is the SIGALRM handler
does not receive the SIGALRM while the thread is being blocked by
IOCTL. And if we generated some event so that the IOCTL is returned
with new information, the SIGALRM handler is invoked right away.
However, as I read the manual, which says a thread/process should be
waken up even when it sleeps if there is a signal delivered to it. Am
I right?
One thing I don't know it mattters or not is that I am not using
sigwait to block the process and wait for signal because the thread
need to go back to the IOCTL call and be slept on that. So I used
sigaction to register the signal handler in hope that this handler wil
be invoked by the kernel when there is an SIGALRM delivered to the
thread.
Could anyone tell me if I did something wrong and what is the correct
way to achieve this task? I tried to avoid creating another thread
which will call sigwait and block until the IOCTL thread send it
explicitly a signal because I want to use timer.


Thank you in advance,
LNgo
