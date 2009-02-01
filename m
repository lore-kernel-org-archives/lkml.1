Return-Path: <linux-kernel-owner+w=401wt.eu-S1756259AbZBAUhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259AbZBAUhX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 15:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbZBAUhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 15:37:09 -0500
Received: from qb-out-0506.google.com ([72.14.204.227]:63340 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbZBAUhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 15:37:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=fIA0XKKh3fCSYFuMr0ifAL6pH8E/DnWnRExrtM6LFdOD+OPxexi5ndMMDSYNMmMPE6
         nXEaGd5XK3lHvIhrQSGKnu50HLvHwno1/JLJ+D5gEtBt6h25PRoe2S3cqdfzxpug6jUM
         C2kxCQbYZm1nNm81REEMObEnHtrnyKjwlL9YY=
Message-ID: <498607EF.5070705@gmail.com>
Date: Sun, 01 Feb 2009 14:37:03 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: George Kumar <grgkumar4@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Killing a kernel thread from user space ?
References: <5f695cd0902011059g518cc6d4of00b8e1e00fe67c5@mail.gmail.com>
In-Reply-To: <5f695cd0902011059g518cc6d4of00b8e1e00fe67c5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

George Kumar wrote:
> Hi,
> 
> Is it possible to kill a kernel thread from user space. Don't ask me
> why do I need to do this. This is purely an experimental exercise, I
> am not doing it because I am working on a practical problem. Thing is
> that I wrote a kernel module and now it is hung in a kernel thread
> somewhere doing udelay(), fortunately since I am on preemptible kernel
>  my machine is not frozen,
> but still I saw that doing a kill -9 on this process has no effect.
> How about if I insert another kernel module and kill this busywait
> thread from inside the kernel space. In effect how do you execute
> "kill -9" from one kernel thread to misbehaving kernel thread.

You can't, really. Kernel threads (or any kernel code) can't be 
interrupted by signals, except where they are explicitly coded so that 
they can be (breaking out of a loop due to signal_pending(), etc.)
