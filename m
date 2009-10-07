Return-Path: <linux-kernel-owner+w=401wt.eu-S1759546AbZJGQZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759546AbZJGQZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 12:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759534AbZJGQZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 12:25:49 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:45606 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759320AbZJGQZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 12:25:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=yAe+dG4E/wqIysN0DvCA959IFajx0tKeI9qilhbfqBksxwnzGHscie2DjRRvNc4hk5
         K2rN6ZMOoAaTfaktLpTqW5yjEZK21Lox3fVCGU1fhbIc3CR3BnSFttugOr901DPsSKVm
         JXipslLXDYHtoK+EQLXiUrxEsMcOl3cqoegnM=
Message-ID: <4ACCC0E3.8050404@tuffmail.co.uk>
Date: Wed, 07 Oct 2009 17:25:07 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] printk: clean up return value
References: <1254904787-11323-1-git-send-email-alan-jenkins@tuffmail.co.uk> <1254904787-11323-2-git-send-email-alan-jenkins@tuffmail.co.uk> <alpine.LFD.2.01.0910070828190.3432@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0910070828190.3432@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Hmm. I kind of agree with this, but at the same time I suspect that no 
> caller should ever care about the loglevel characters (since they won't be 
> _shown_), so your change still doesn't make it return a sensible value.
>
> So I get the feeling that you should also add a
>
> 	message_len -= 3;
>
> to the case where we peel off the "<.>" loglevel part at the head of the 
> string. No?
>   

The value is only really sensible for partial printk()s... except that
they're supposed to be prefixed with KERN_CONT.  So yes, good point.

> Or we could just change it to 'void'. As Joe Perches says, nobody really 
> cares deeply enough for this to generally even matter.
>   

That involves more work, which explains why I shied away from it :-). 
Ok, I'll do it.

Alan
