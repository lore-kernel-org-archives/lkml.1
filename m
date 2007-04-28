Return-Path: <linux-kernel-owner+w=401wt.eu-S1751884AbXD1PQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbXD1PQf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 11:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbXD1PQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 11:16:35 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:30355 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbXD1PQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 11:16:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=URDAWCJN3CnNQEu+9Xawb6f+HNSiAI2p/N5vtPdpoMI8gui/3EE5US3alAIFfFz1ikIY+ZY7St7Vwhet26zfrB+OUL8yHshqFOg55CgurqHCUUPGs3G9cIucrTwxT0S2SYKFmnZ87uCAXvVWyvqn9Y2Mq+kYhnjhReaK+fhMI3I=
Date: Sat, 28 Apr 2007 23:20:40 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       "Shan, Guo Wen (Gavin)" <gshan@alcatel-lucent.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: can a kmalloc be both GFP_ATOMIC and GFP_KERNEL at the same time?
Message-ID: <20070428152040.GA3558@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: Arjan van de Ven <arjan@infradead.org>,
	"Robert P. J. Day" <rpjday@mindspring.com>,
	"Shan, Guo Wen (Gavin)" <gshan@alcatel-lucent.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <2AC135F730C4A045BAE4F1C1CB83FD4B03EF6F87@exch03.qd.lucent.com> <Pine.LNX.4.64.0704281006380.25313@localhost.localdomain> <1177772622.3477.0.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177772622.3477.0.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 08:03:42AM -0700, Arjan van de Ven wrote:
>
>> >
>> >
>> >   i'd always assumed that the type flags of GFP_ATOMIC and GFP_KERNEL
>> > were mutually exclusive when it came to calling kmalloc(), at least
>> > based on everything i'd read.  so i'm not sure how to interpret the
>> > following:
>> >
>> > drivers/scsi/aic7xxx_old.c:  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_ATOMIC | GFP_KERNEL);
>> > drivers/message/i2o/device.c:   resblk = kmalloc(buflen + 8, GFP_KERNEL | GFP_ATOMIC);
>> >
>> >   clarification?
>> 
>> oh, i'm *aware* of the definitions of those flags, but every single
>> source i've ever read has *strongly* suggested that you don't use
>> those two flags together so i was surprised to see those combinations.
>> (as an example, love's kernel book, p. 192, shows a table of valid
>> combinations of flags to use, but doesn't mention the one above.)
>> 
>> and, on the other hand, if they *are* legal to use together, i guess
>> i'm kind of surprised that there would be only two instances of it.
>
>it's not legal to use the combo; you have found yourself a very genuine
>bug here! Good spotting!

Yes. LDD already talked about this. GFP_KERNEL may cause sleeping while GFP_ATOMIC not. Combining them is confusing. 


