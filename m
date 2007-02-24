Return-Path: <linux-kernel-owner+w=401wt.eu-S933360AbXBXDcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933360AbXBXDcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 22:32:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933361AbXBXDcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 22:32:50 -0500
Received: from smtp-out.google.com ([216.239.45.13]:22538 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933360AbXBXDct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 22:32:49 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=KPpuAlGM832RlHy2HkIqCmo7rdR14hkJJWId6cljqCrb/z0YgqA7DsvGV0LWIT6Q5
	0mWa+t/0RvgqaPiDjO6YA==
Message-ID: <45DFB1C7.1030205@google.com>
Date: Fri, 23 Feb 2007 19:32:23 -0800
From: Markus Gutschke <markus@google.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20060909)
MIME-Version: 1.0
To: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
CC: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Robin Holt <holt@sgi.com>,
       dhowells@redhat.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>
Subject: Re: [PATCH 0/4] coredump: core dump masking support v3
References: <45D5B2E3.3030607@hitachi.com>
In-Reply-To: <45D5B2E3.3030607@hitachi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kawai, Hidehiro wrote:
> This patch series is version 3 of the core dump masking feature,
> which provides a per-process flag not to dump anonymous shared
> memory segments.

I just wanted to remind you that you need to be careful about dumping 
the [vdso] segment no matter whether you omit other segments. I didn't 
actually try running your patches, and if the kernel doesn't actually 
consider this segment anonymous and shared, things might already work 
fine as is.

In any case, you can check with "readelf -a", if the [vdso] segment is 
there. And you will find that if you forget to dump it, "gdb" can no 
longer give you stack traces on call chains that involve signal handlers.

As an alternative to your kernel patch, you could achieve the same goal 
in user space, by linking my coredumper 
http://code.google.com/p/google-coredumper/ into your binaries and 
setting up appropriate signal handlers. An equivalent patch for 
selectively omitting memory regions would be trivial to add. While this 
does give you more flexibility, it of course has the drawback of 
requiring you to change your applications, so there still is some 
benefit in a kernelspace solution.


Markus
