Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbZEPBPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbZEPBPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 21:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbZEPBPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 21:15:37 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:34637 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbZEPBPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 21:15:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Jom2Alm97KDaa9omgMwH92gs3P8GZQstUxPKAFGZyJ1LV9fEv9JKIkyFF3OI0DLgyS
         6oHmgsTnltL3DAFRoQ/N8l73mIEXOkEoIhRahh6oOV/Bw77YgkHc18v5+KcarJuDCw5z
         5RyOzXnOkJe74neU0nhD2S1TPWmj9cjldUBwQ=
Message-ID: <4A0E13B7.90200@gmail.com>
Date: Fri, 15 May 2009 19:15:35 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Sudarshan Soma <sudarshan12s@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: patch related to SIGSEGV handling in multiple threads and hung
    threads
References: <de72ca4e0905150405w495a359ei7c4a625ff82edb11@mail.gmail.com>
In-Reply-To: <de72ca4e0905150405w495a359ei7c4a625ff82edb11@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sudarshan Soma wrote:
> Hi ,
> I have a program which will create multiple threads. One of the thread
> receives SIGSEGV and it prints stacktrace in its handler and calls
> _exit(-1). The call to exit wont terminate all threads in  a process
> and hence thread hangs here. This causes resouce leaks and other
> problems. It is seen only on linux 2.4.20.
> 
> For printing stacktrace it uses
> __builtin_return_address and __builtin_frame_address
> 
> 
> The same program works fine on linux 2.6.26 kernel. It  will exit the
> whole process when one of its thread dies as above.
> 
> 
> Please let me know the patch details or any workaround, if any. This
> is a bit urgent, so please let me know for any pointers , if any
> 
> Thanks and Best Regards,
> Pavan.

That doesn't seem surprising, the old LinuxThreads thread implementation 
normally used with the 2.4 kernels was pretty poor. However it would 
likely be better to re-raise the signal rather than trying to exit out 
of the signal handler.
