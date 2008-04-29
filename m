Return-Path: <linux-kernel-owner+w=401wt.eu-S1756430AbYD2H6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbYD2H6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 03:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbYD2H6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 03:58:32 -0400
Received: from hu-out-0506.google.com ([72.14.214.228]:49732 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbYD2H6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 03:58:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:x-x-sender:to:cc:subject:in-reply-to:message-id:references:user-agent:mime-version:content-type:from;
        b=Y/z7L6T08UY5I3CsCAH5HBRgXQryIS5eLQ03gIegz0ZeDUcXwJ+qyEL6GRo0CFjtjSBaBHMeW3WzzfagM9jI5CVB3BNmqhCsHDggzBydtWiFo8KbYAyHuW92ReU1HeYjGWEoFQogVmdUh11BkRuJ9b3sZLVoAU0zaWCK1YESqVU=
Date: Tue, 29 Apr 2008 15:57:24 +0800 (CST)
X-X-Sender: wangcong@localhost.localdomain
To: Jeff Dike <jdike@addtoit.com>
cc: WANG Cong <xiyou.wangcong@gmail.com>, akpm@osdl.org,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/19] UML - Tidy stub management code
In-Reply-To: <20080428154524.GE7334@c2.user-mode-linux.org>
Message-ID: <alpine.LFD.1.00.0804291556550.2548@localhost.localdomain>
References: <20080425175606.GA11174@c2.user-mode-linux.org> <20080426.180112.184545994.xiyou.wangcong@gmail.com> <20080428154524.GE7334@c2.user-mode-linux.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
From: WANG Cong <xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008, Jeff Dike wrote:

> On Sat, Apr 26, 2008 at 06:01:12PM +0800, WANG Cong wrote:
>> > +	/*
>> > +	 * When the stub stops, we find the following values on the
>> > +	 * beginning of the stack:
>> > +	 * (long) return_value
>> > +	 * (long) offset to failed sycall data (0 if no error)
>> > +	 */
>> > +	ret = *((unsigned long *) stack);
>> 
>> 
>> I am afraid the value will be truncated on 64bit machine, since
>> 'ret' is 'int' while 'stack' points to an 'unsigned long'.
>> 
>> Is this expected?
>
> That's dubious, but I don't think it breaks anything.  On LE, *(int *)
> and *(long *) will give you the same answer, and the value here is an
> error code, which fits into 32 bits.

So it's safe here.

OK. Thanks!

--
Hi, I'm a .signature virus, please copy/paste me to help me spread
all over the world.
