Return-Path: <linux-kernel-owner+w=401wt.eu-S1758865AbZEBT4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865AbZEBT4V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 15:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758556AbZEBTzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 15:55:53 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:45923 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758274AbZEBTzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 15:55:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RoSwZulFbEsebUaMBk6XnMyCLPGUS71CMqsvqSzEL/80V7smes4pYz4T0vMPp46UKn
         xLtXvcd4IyJN0g0gV7TVPFYRqcGiUEXtiypdb3/8aiC6LsywrUxQKBgkjpBnGtqhfshq
         RrKoN9waU7FMLB6vCdya62w8EhrLIviI8Ng1U=
MIME-Version: 1.0
In-Reply-To: <49FC8EE4.6040408@googlemail.com>
References: <1241097822.2516.3.camel@poy>
	 <20090430222900.c13b63d5.akpm@linux-foundation.org>
	 <20090501061701.GB19234@kroah.com>
	 <20090430234312.a63fa5cf.akpm@linux-foundation.org>
	 <20090501065527.GA19773@kroah.com>
	 <20090501120359.05bacb48@lxorguk.ukuu.org.uk>
	 <ac3eb2510905010411r2c1a2be5s449aaf485a76a8c4@mail.gmail.com>
	 <20090501141846.4b833700@lxorguk.ukuu.org.uk>
	 <ac3eb2510905010624k891f680s7255af8ae185b5d5@mail.gmail.com>
	 <49FC8EE4.6040408@googlemail.com>
Date: Sat, 2 May 2009 20:55:49 +0100
Message-ID: <9b2b86520905021255t4a4812dcrcbcc32f36acd6039@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Michael Riepe <michael.riepe@googlemail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/09, Michael Riepe <michael.riepe@googlemail.com> wrote:
> Hi!
>
> Kay Sievers wrote:
>> On Fri, May 1, 2009 at 15:18, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>>
>>>>No tool ever has a chance to get to the information only available at
>>>>early kernel init. All such tools will need to "replay" what the
>>>>kernel already did. This is intended to save us from doing this, and
>>>>retain the information which is there, but lost at the moment the
>>>>tools have the first chance to run.
>>>
>>>Serious question - which is the better problem to fix ?
>>
>>
>> I'm very sure, you can not fix it outside the kernel. Or do you have
>> an idea how to create the missing device nodes for device without
>> crawling sysfs, when the first userspace process is started?
>
> Well, what about this? Let the kernel buffer all events until udev is
> ready to process them. Once it signals that it's up and running - the
> best method for that is tbd -, empty the queue, and then discard it,
> including the additional code. If udev doesn't come up in time after
> init has started, or the buffer overflows, assume the system is using a
> static /dev and throw away the queue as well. If udev starts too late,
> it can still do a coldplug - in that case, boot speed is already so low
> that the additional delay hardly matters.

Already answered by Kay.
<http://groups.google.com/group/linux.kernel/msg/9851b3f5e82d65ef>

But the premise of this question is bogus anyway.  You don't gain
anything by capturing events earlier; replaying them is really quite
cheap, and extracting device numbers and names from sysfs is even
cheaper.  The gains are in reducing how much processing you need to do
on them.  Both in terms of performance, and in making it
simple/neutral enough to be considered for kernel inclusion, which in
turn brings a number of small benefits.

Alan
