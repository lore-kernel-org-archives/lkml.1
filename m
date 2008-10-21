Return-Path: <linux-kernel-owner+w=401wt.eu-S1752061AbYJUHWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbYJUHWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 03:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750971AbYJUHWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 03:22:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:30509 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbYJUHWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 03:22:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=KVJPErDOIsnNaH/gTrHejVaoTUZgGJ9kRegDy+iO6aadT1lpnfOXKksAuDYDc7N0Ns
         a8AAhM24i09I9so8s1LlDvUExGB02D7Oh5fgsYGfJPe43n3cXTKdYQAKmS6tK7MdOCHq
         7CYXMt7iL1ZcaqFfruSRAPQT5xCO2v4nsGLaY=
Message-ID: <86802c440810210022i75d3c081r8fc979386cdda9ce@mail.gmail.com>
Date: Tue, 21 Oct 2008 00:22:21 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: benh@kernel.crashing.org
Subject: Re: Bug in "genirq: record trigger type"
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "linuxppc-dev list" <linuxppc-dev@ozlabs.org>
In-Reply-To: <1224570730.7654.242.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200810202205.m9KM5une024759@hera.kernel.org>
	 <1224570730.7654.242.camel@pasglop>
X-Google-Sender-Auth: c42e55baec0893eb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 11:32 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Mon, 2008-10-20 at 22:05 +0000, Linux Kernel Mailing List wrote:
>> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0c5d1eb77a8be917b638344a22afe1398236482b
>> Commit:     0c5d1eb77a8be917b638344a22afe1398236482b
>> Parent:     d6d5aeb661fc14655c417f3582ae7ec52985d2a8
>> Author:     David Brownell <dbrownell@users.sourceforge.net>
>> AuthorDate: Wed Oct 1 14:46:18 2008 -0700
>> Committer:  Ingo Molnar <mingo@elte.hu>
>> CommitDate: Thu Oct 2 10:24:09 2008 +0200
>
> This one is obviously broken and breaks booting on a whole bunch of
> machines (including powermac's and thus my G5, it's never good when my
> own machine breaks !).
>
> Nice to see 3 SOB's and one Ack and nobody caught the obvious bug :-)
>
>>       desc = irq_desc + irq;
>> -     if (desc->chip->set_type) {
>> -             spin_lock_irqsave(&desc->lock, flags);
>> -             ret = desc->chip->set_type(irq, type);
>> -             spin_unlock_irqrestore(&desc->lock, flags);
>> -     }
>> +     if (type == IRQ_TYPE_NONE)
>> +             return 0;
>> +
>> +     spin_lock_irqsave(&desc->lock, flags);
>> +     ret = __irq_set_trigger(desc, irq, flags);
>                                             ^^^^ type maybe ?
>
>> +     spin_unlock_irqrestore(&desc->lock, flags);
>>       return ret;
>>  }
>
> I have to run so no patch until tomorrow unless somebody beats me to it.

there is patch about it, but somehow get lost.

YH
