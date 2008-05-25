Return-Path: <linux-kernel-owner+w=401wt.eu-S1756451AbYEYDnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451AbYEYDnY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 23:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbYEYDnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 23:43:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbYEYDnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 23:43:16 -0400
Date: Sat, 24 May 2008 23:41:34 -0400
From: Kristian =?utf-8?B?SMO4Z3NiZXJn?= <krh@bitplanet.net>
To: devzero@web.de
Cc: krh@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Only print "Decompressing Linux" etc when 'noisy'
	is passed.
Message-ID: <20080525034134.GA2392@bitplanet.net>
References: <290568367@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <290568367@web.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 09:28:21PM +0200, devzero@web.de wrote:
> what about using "quiet" here instead ?
> 
> quiet is already the parameter to suppress boot messages, so introducing another one doesn`t make sense, imho.

I agree, and I wasn't looking to introduce a new parameter, I meant to
reuse 'debug'.  That is already used for increasing the log level
(see init/main.c).  Also, as it is, the decompressor already prints
error messages if something goes wrong, so there's not much point in
printing the debug spew.  I think it makes sense to default to not
print it.

> the early boot commandline parser was extended some time ago to support boolean options, see:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=32d0b9898029b7b3c7f161d31f57c4831d9049eb
> 
> this may shrink your patch , see example in arch/x86/boot/edd.c 

Unfortunately, that doesn't help me.  This code is run before the kernel
is decompressed and the only functions available are the ones in misc.c.
And I know the strnstr approach isn't quite smart enough the handle quoted
parameters and similar, but I think it strikes a good balance.

I'll send an updated patch that looks for 'debug' instead of 'noisy'.

thanks,
Kristian

