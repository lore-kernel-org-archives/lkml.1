Return-Path: <linux-kernel-owner+w=401wt.eu-S1760130AbXEKMSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760130AbXEKMSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 08:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510AbXEKMSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 08:18:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756082AbXEKMSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 08:18:37 -0400
Message-ID: <46445EB9.8040106@redhat.com>
Date: Fri, 11 May 2007 08:16:57 -0400
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Li Yu <raise.sail@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       Esben Nielsen <nielsen.esben@googlemail.com>
Subject: Re: Hi, I have one question about rt_mutex.
References: <4642CCEB.6010908@gmail.com> <4643176C.6050305@redhat.com> <4643CD44.1090903@gmail.com>
In-Reply-To: <4643CD44.1090903@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Li Yu wrote:
> 
> However, I found the sys_futex() do not use rt_mutex, so what's mean of the user futex you said?
> Even, I have not found any usage for rt_mutex in kernel code. Or, some beautiful story will happen in future?
> 

Just need to look a little deeper :-)


sys_futex calls do_futex

do_futex with the option of FUTEX_LOCK_PI will call futex_lock_pi

futex_lock_pi calls rt_mutex_timed_lock or rt_mutex_trylock  both of
which are part of the rtmutex.c code.


So it's there today :-)

-- Steve

