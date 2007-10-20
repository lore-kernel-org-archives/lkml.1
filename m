Return-Path: <linux-kernel-owner+w=401wt.eu-S1764225AbXJTBI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764225AbXJTBI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 21:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbXJTBIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 21:08:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:18568 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbXJTBIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 21:08:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=qmM8M6WEY17G5/gluv+rOTpuAGBrU1FzV8OJlEzU+C5Q1d3FVv+xO2mvOQzZn9EWABiLYwoWMIC6fJzDL4nZcI0rtuYSaA8VSjucbDXnzezhkzQTwNOzyOsEXA7yHK7v+6clZJ6e+4RamZJYyWzbaaQpln7IVO+UcazPULNWoaA=
Message-ID: <2c0942db0710191808u7e417ac7ra93583fd15ffab36@mail.gmail.com>
Date: Fri, 19 Oct 2007 18:08:20 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [2.6.23] tasks stuck in running state?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <47192425.6020507@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47192425.6020507@garzik.org>
X-Google-Sender-Auth: 01542896399b553d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/07, Jeff Garzik <jeff@garzik.org> wrote:
> On my main devel box, vanilla 2.6.23 on x86-64/Fedora-7, I'm seeing a
> certain behavior at least once a day.  I'll start a kernel build (make
> -sj5 on this box), and it will "hang" in the following way:
>
> > 31003 ?        S      0:04 sshd: jgarzik@pts/0
> > 31004 pts/0    Ss     0:02  \_ -bash
> >  8280 pts/0    S+     0:00      \_ make ARCH=i386 -sj4
> >  8690 pts/0    Z+     0:00          \_ [rm] <defunct>
> >  8691 pts/0    S+     0:00          \_ /bin/sh -c cat include/config/kernel.release 2> /dev/null
> >  8692 pts/0    R+     6:12              \_ cat include/config/kernel.release
>
> Specifically, the symptom is a process, often a simple one like cat(1)
> or rm(1) or somewhere in check-headers, will stay in the running state,
> accumulating CPU time.
>
> If I Ctrl-C the build, and start over, the build will normally -not- get
> stuck at the same point, but proceed to chew through one of a bazillion
> allmodconfig builds.

I *think* I'm seeing this with firefox under 2.6.23-rc6. I tried a
`killall -SIGSTOP firefox; killall -SIGCONT firefox` and when I looked
back it was back to life again, but that may have been a fluke.
Regardless, try that the next time it happens?

Ray
