Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbZCKPHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbZCKPHP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 11:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbZCKPHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 11:07:00 -0400
Received: from mail-bw0-f178.google.com ([209.85.218.178]:63215 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbZCKPG7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 11:06:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=S8goBMnUH6zvLUqAq2nud8+seJW0sXZI6QsfJnUTUJSeCYhi9AaUAp1vvrVQvi68nx
         4j7xn1/QBpB4gHdTloAfT6xqpy4846HFpo683uhcjAqp74o+la68fYHucyX1zWWTjr6t
         BlmOnSOf3zZdJMfQS0BroxQvK3sdQzi11i4OU=
MIME-Version: 1.0
In-Reply-To: <200903111439.57510.thomas.schoebel-theuer@1und1.de>
References: <e2dc2c680903110341g6c9644b8j87ce3b364807e37f@mail.gmail.com>
	 <200903111439.57510.thomas.schoebel-theuer@1und1.de>
Date: Wed, 11 Mar 2009 16:06:55 +0100
Message-ID: <e2dc2c680903110806r56750933q19ed1c71e60bec9c@mail.gmail.com>
Subject: Re: Memory usage per memory zone
From: jack marrow <jackmarrow2@gmail.com>
To: Thomas Schoebel-Theuer <thomas.schoebel-theuer@1und1.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/11 Thomas Schoebel-Theuer <thomas.schoebel-theuer@1und1.de>:
> Am Mittwoch, 11. März 2009 11:41:43 schrieb jack marrow:
>> I have a box where the oom-killer is killing processes due to running
>> out of memory in zone_normal. I can see using slabtop that the inode
>> caches are using up lots of memory and guess this is the problem, so
>> have cleared them using an echo to drop_caches.
>
> Hi Jack,
>
> my experience with plain old 2.6.24 on 32bit _production_ boxes was that under
> heavy load and after >30days uptime we saw an sudden inflation of oom-killers
> on some of them until those boxes died. The standard kernel statistics about
> memory looked much the same as yours (and I suspect they could have been
> wrong or at least misleading, but I have neither checked nor tried to fix).
>
>> is it possible to use slabtop
>> (or any other way) to view ram usage per zone so I can pick out the
>> culprit?
>
> Try the attached experimental hack which can provide you with some insight
> about whats really going on in the _physical_ memory. Since it does not
> allocate any memory for the purpose of displaying those memory patterns it
> wants to examine, you have to allocate a large enough buffer in userspace.
> Don't use cat, but something like dd with parameters such as bs=4M (as
> mentioned in the comment). Probably you have to adjust the patch to some
> newer kernel versions, and/or to fix some sysctl table checks if you want to
> get it upstreams (I will not). And, of course, you can visualize more/other
> flags as well.
>
> After gaining some insight with /proc/sys/vm/mempattern and some development
> of further experimental patches which successfully reduced fragmentation (but
> finally only _delayed_ the oom problems without being able to _fundamentally_
> resolve them), the ultimate solution was just to use CONFIG_VMSPLIT_2G or
> even CONFIG_VMSPLIT_1G in order to overcome the artificial shortening of
> zone_normal.
>
> This supports old wisdom that an OS cannot give you resources it just does not
> possess... Just make sure you have enough resources for your working set.
> Thats all.
>
> In the hope of being helpful,
>
> Thomas
>

Thanks a lot for this Thomas. I'm not able to run a patched kernel on
this box, but I'll keep this in mind for future.
