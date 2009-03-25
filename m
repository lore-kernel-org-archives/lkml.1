Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbZCYVVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbZCYVVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 17:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZCYVV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 17:21:28 -0400
Received: from gw.goop.org ([64.81.55.164]:55546 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391AbZCYVV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 17:21:28 -0400
Message-ID: <49CAA055.5060603@goop.org>
Date: Wed, 25 Mar 2009 14:21:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: nicolas sitbon <nicolas.sitbon@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: epoll_ctl and const correctness
References: <84a01a8b0903250545n799a8727o1faad60c8eaf372e@mail.gmail.com>
In-Reply-To: <84a01a8b0903250545n799a8727o1faad60c8eaf372e@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nicolas sitbon wrote:
> valgrind confirms this
> behaviour, so am I wrong?

That doesn't prove very much.  Unlike usermode code, Valgrind doesn't 
instrument the kernel, so it computes the side-effects of kernel 
operations by parsing the syscall stream and simulating the effect.  
(That is to say, it strengthens your argument somewhat, but valgrind's 
handling of this syscall could be buggy.)

>  or the good prototype is
>
> int epoll_ctl(int epfd, int op, int fd, struct epoll_event const *event);
>   

Putting "const" first is conventional.

    J
