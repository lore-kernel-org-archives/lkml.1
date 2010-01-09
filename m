Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400Ab0AIXvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab0AIXvm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 18:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606Ab0AIXvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 18:51:42 -0500
Received: from mail-iw0-f194.google.com ([209.85.223.194]:44109 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab0AIXvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 18:51:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lnfgUNSauWw3B8mxWyOprcPWYdBdO9fucThKyD+P42TsU7Jvl2vL7JXEFQ7GM90jPI
         6DEeJRMAGwRfHWQEQuzl0fGr5hq/QnZblCbafXJT8umVYi9ejn0iI3P82Ohv+J7duxw+
         nQ8dBjd6oIZf4eKRkgpOUQt9w2mNou9Vkj7TA=
Message-ID: <4B49168A.9050201@gmail.com>
Date: Sat, 09 Jan 2010 17:51:38 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: "Paul G. Allen" <pgallen@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux Serial Performance
References: <bd8e30a41001091057t97f90abgffe9cca329ace477@mail.gmail.com>
In-Reply-To: <bd8e30a41001091057t97f90abgffe9cca329ace477@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2010 12:57 PM, Paul G. Allen wrote:
> I have been working on an application for work written in Java. It's a
> production system used for loading firmware into embedded devices via
> RS-232. It is designed to load multiple devices in parallel (tested
> with up to 32 on a machine thus far). With another Java application
> running on Windows XP, a single unit would take about 1 min to load
> ~400,000 byte binary image. I ported this code to the production
> system on Linux and it took over 15 min to load a single unit.
>
> I ran some tests on Windows XP and Linux CentOS 5.1 using the Sun
> NetBeans IDE 6.7.1 profiler. The same Java code on both Linux and XP
> machines, the same model of machine (Dell, Pentium 4 3GHz, 2.5GB
> memory). I am using the Sun comm API currently, and previously I was
> using the Serlio API. In all cases, the profiler shows the serial Tx
> to be about 20x faster (twenty times) on Windows XP than in Linux. It
> takes Linux several seconds to Tx 1024 byte blocks of data over the
> serial port where Windows XP takes a fraction of a second. I had also
> noticed that Linux seemed to be very slow in 2006-2007 when using
> Fedora (can't recall which version) and the Serialio API, but at that
> time I could not get Windows to work at all. This has forced us to
> lean toward the use of Windows (and pay for licensing for multiple
> machines, etc.) instead of Linux for every system that will be used in
> testing and manufacture of our product.
>
> I am wondering, have there been any performance tests comparing Linux
> serial IO to Windows and what was the result? Is it a problem in the
> comm API (e.g. - the Windows DLL having better performance than the
> Linux .so)? Is it a problem in the Linux serial driver itself? Is
> there something I can/need to do on Linux to tweak the driver and make
> it faster?

It seems unlikely that there's a kernel bottleneck of this magnitude in 
the serial code for something that simple. Seems more likely to me that 
the Java VM's serial communications code is doing something silly. Have 
you tried running strace on your process to see if the syscalls 
accessing the serial port look strange? What's the CPU usage like when 
this is running?
