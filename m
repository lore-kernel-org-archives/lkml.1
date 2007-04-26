Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbXDZWPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbXDZWPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 18:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbXDZWPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 18:15:49 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:35249
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbXDZWPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 18:15:48 -0400
Message-ID: <46313292.4000205@microgate.com>
Date: Thu, 26 Apr 2007 17:15:30 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: compat_ioctl question
References: <1177620717.5060.11.camel@amdx2.microgate.com> <200704262337.56240.arnd@arndb.de> <46312AEE.1000302@microgate.com> <200704270008.58811.arnd@arndb.de>
In-Reply-To: <200704270008.58811.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> So you are interested in the MGSL_* set of ioctls, right?
> AFAICS, they are all compatible, with the exception of
> MGSL_IOCGPARAMS and MGSL_IOCSPARAMS.
> 
> Fortunately, these two have different ioctl numbers on
> 64 bit, so you can define a new
>  
> #define MGSL_IOCSPARAMS32 _IOR(MGSL_MAGIC_IOC,0,struct _MGSL_PARAMS32)
> #define MGSL_IOCGPARAMS32 _IOR(MGSL_MAGIC_IOC,1,struct _MGSL_PARAMS32)
> 
> and handle both versions in the ioctl function.

I missed that approach, thanks.

> Yes, that would be the right solution. I've started this
> some time ago, but never finished it:
> http://www.uwsg.iu.edu/hypermail/linux/kernel/0511.0/1732.html
> 
>> Currently the tty file ops do not include that and
>> tty_io.c does not register a compat_ioctl(), instead
>> relying on compat_ioctl.h and compat_ioctl.c
> 
> Just adding the hook in tty_io.c should be trivial, please do that.
> If you like, you can also move the vt ioctls in order to reduce
> the size of fs/compat_ioctl.c.

I'll look at that.

You have given me precisely the information I need.

I just wanted to be sure I did not pursue a dead end
and have people go 'ewwww... why did you do it that way?'

Thanks,
Paul

