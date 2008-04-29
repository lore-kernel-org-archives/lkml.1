Return-Path: <linux-kernel-owner+w=401wt.eu-S1760292AbYD2IP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760292AbYD2IP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 04:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755482AbYD2IPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 04:15:39 -0400
Received: from rv-out-0708.google.com ([209.85.198.249]:11530 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752014AbYD2IPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 04:15:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:x-x-sender:to:cc:subject:in-reply-to:message-id:references:user-agent:mime-version:content-type:from;
        b=N8arWB25ISEZrdqgi26wsQSRZLeVSQrYRtOqnTA+04r1iQT/YpNvvHcpjFkMP06KH0+uwTqUjBJ7vdx6PP9EE6Q6amW6QPr53XBRAmwmcysiNV+ac7ZlTRkYYzmIeQItcV4Jic8sQkq2dMDsqOI91eR30aMBYTnRXhRQg7JUuhE=
Date: Tue, 29 Apr 2008 16:14:25 +0800 (CST)
X-X-Sender: wangcong@localhost.localdomain
To: Jeff Dike <jdike@addtoit.com>
cc: WANG Cong <xiyou.wangcong@gmail.com>, akpm@osdl.org,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 9/19] UML - Tidy ptrace interface
In-Reply-To: <20080428154240.GD7334@c2.user-mode-linux.org>
Message-ID: <alpine.LFD.1.00.0804291613570.2548@localhost.localdomain>
References: <20080425175610.GA11188@c2.user-mode-linux.org> <20080426.173538.195417245.xiyou.wangcong@gmail.com> <20080428154240.GD7334@c2.user-mode-linux.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
From: WANG Cong <xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008, Jeff Dike wrote:

> On Sat, Apr 26, 2008 at 05:35:38PM +0800, WANG Cong wrote:
>> From: Jeff Dike <jdike@addtoit.com>
>> Date: Fri, 25 Apr 2008 13:56:10 -0400
>> > Tidy the ptrace interface code.  Removed a bunch of unused macros.
>> > Started converting register sets from arrays of longs to structures.
>> 
>> Could you please explain a bit why do this? I think long arrary is OK.
>
> It's wrong on x86_64.  There, FRAME_SIZE is 168 -
>     #define FRAME_SIZE 
> and SS is the last register defined -
>    #define SS 160
> but there are a number of registers beyond that in the user_regs_struct:
> 	unsigned long	ss;
> 	unsigned long	fs_base;
> 	unsigned long	gs_base;
> 	unsigned long	ds;
> 	unsigned long	es;
> 	unsigned long	fs;
> 	unsigned long	gs;
>
> The effect of GETREGS into a long[FRAME_SIZE] will be stack corruption.
>

Thanks for teaching this. ;-)

--
Hi, I'm a .signature virus, please copy/paste me to help me spread
all over the world.
