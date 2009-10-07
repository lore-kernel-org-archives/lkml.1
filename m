Return-Path: <linux-kernel-owner+w=401wt.eu-S1759584AbZJGQ6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759584AbZJGQ6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 12:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759520AbZJGQ6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 12:58:14 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:63529 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759519AbZJGQ6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 12:58:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lUiYcsd0TTSvewe34QU/emqb1dDPvxf1pIYUXKpQskFTLl9Hgg3Poj6950dV7Bb5S3
         RPSPRw/l+EawM15BaHckca0g75mGRTxRc8K8QC+jBLULX54WHC5WVTGNUWAuGW/dLzkZ
         EqPraESfnG55AbLaaOnH3fvXPNlIagbxszKNU=
Message-ID: <4ACCC87C.5090800@tuffmail.co.uk>
Date: Wed, 07 Oct 2009 17:57:32 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] printk: clean up return value
References: <1254904787-11323-1-git-send-email-alan-jenkins@tuffmail.co.uk>	 <1254904787-11323-2-git-send-email-alan-jenkins@tuffmail.co.uk>	 <alpine.LFD.2.01.0910070828190.3432@localhost.localdomain> <1254933396.2134.371.camel@Joe-Laptop.home>
In-Reply-To: <1254933396.2134.371.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Wed, 2009-10-07 at 08:36 -0700, Linus Torvalds wrote:
>   
>> On Wed, 7 Oct 2009, Alan Jenkins wrote:
>>     
>>> We could fix this up, but it seems pointless.  Callers don't really care
>>> about the extra characters added by printk().  Instead, let's return the
>>> length of the original message as formatted (and possibly truncated)
>>> by vscnprintf().
>>>       
>> Or we could just change it to 'void'. As Joe Perches says, nobody really 
>> cares deeply enough for this to generally even matter.
>>     
>
> Here are changes to make printk/vprintk return void
> to the only uses I found:
>
>  arch/arm/mach-iop13xx/pci.c   |    2 +-
>  arch/arm/mach-iop13xx/setup.c |    2 +-
>  drivers/char/mem.c            |    6 ++----
>  drivers/md/md.c               |    3 +--
>  drivers/md/raid5.c            |    3 ++-
>  drivers/net/e100.c            |    9 +++++----
>  include/linux/kernel.h        |   16 ++++++++--------
>  include/net/sctp/sctp.h       |    6 +++---
>  kernel/lockdep.c              |    4 ++--
>  kernel/printk.c               |   10 +++-------
>  net/sunrpc/svc.c              |    9 +++------
>  11 files changed, 31 insertions(+), 39 deletions(-)
>   

Ok, you beat me to it.

My second patch will depend on this.  Two questions -

- May I add it to my series with your Signed-off-by?
- May I split it up, so I can CC individual maintainers with the
revelant portions?

Thanks
Alan

