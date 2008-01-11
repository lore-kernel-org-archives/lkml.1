Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbYAKCE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbYAKCE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 21:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754266AbYAKCEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 21:04:50 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:36660 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbYAKCEu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 21:04:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=vsEiP5jY0tzrsn+OAMFaIU5mYDDo6tBC+LvOwzxqH3Qkh6KjZd9gg6bCFy3Xhgu4AlpH2ODrfQE599XOYaI7VZs5eDenVt9o2xwH4HnzSAa/jz2j0ICdc9Xma301Gwm2oXeSatInCoj1ElTvDzfXKGC7ZtROPurxhq+IMzr7VzQ=
Date: Thu, 10 Jan 2008 22:04:44 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: hwclock failure in x86.git
Message-Id: <20080110220444.4c9efdec.kjwinchester@gmail.com>
In-Reply-To: <4786C2CF.4070204@zytor.com>
References: <4786AA11.5010805@gmail.com>
	<4786AB1B.4030004@zytor.com>
	<4786AF4C.6050509@gmail.com>
	<4786C2CF.4070204@zytor.com>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008 17:13:51 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Kevin Winchester wrote:
> > H. Peter Anvin wrote:
> >> Kevin Winchester wrote:
> >>> My first time building and booting the mm branch of x86.git was pretty
> >>> successful.  The only error I noticed was the following in my dmesg:
> >>>
> >>>  hwclock[622] general protection ip:804b226 sp:bff43e30 error:0
> >>>
> >>> I'm not sure exactly how to debug this.  I could bisect, but there seems
> >>> to be some useful debug information in there, so there might be
> >>> something better to try first.
> >>>
> >> That's a userspace IP; it implies the userspace hwclock binary did 
> >> something bad, or the kernel didn't permit it to do something it should 
> >> have.  The best thing to do would probably to strace hwclock and see 
> >> what it did when it died.
> >>
> > 
> > Unfortunately, but the time I can get a chance to run hwclock, the
> > problem seems to have fixed itself.  I tried booting into single user
> > mode, but `/etc/init.d/hwclock.sh restart` succeeds once I have my prompt.
> > 
> 
> The other thing you can do is to download the debug information and 
> source code for hwclock from your particular distro, and find out 
> exactly what operation inside the hwclock binary is triggering the segfault.
> 
> The only other option is to bisect.
> 

Bisect says...

4b5ea240a0c05ff90c4959fd91f0caec7b9bef1b is first bad commit
commit 4b5ea240a0c05ff90c4959fd91f0caec7b9bef1b
Author: mboton@gmail.com <mboton@gmail.com>
Date:   Wed Jan 9 13:31:11 2008 +0100

    x86: ioport_{32|64}.c unification
    
    ioport_{32|64}.c unification.
    
    This patch unifies the code from the ioport_32.c and ioport_64.c files.
    
    Tested and working fine with i386 and x86_64 kernels.
    
    Signed-off-by: Miguel Botón <mboton@gmail.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

I'll take a look at the unification and see if I can see anything obvious.

-- 
Kevin Winchester <kjwinchester@gmail.com>
