Return-Path: <linux-kernel-owner+w=401wt.eu-S1760121AbYGAPML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760121AbYGAPML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 11:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758142AbYGAPLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 11:11:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758891AbYGAPLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 11:11:52 -0400
Message-ID: <486A4908.103@redhat.com>
Date: Tue, 01 Jul 2008 12:11:04 -0300
From: Glauber Costa <gcosta@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       x86@kernel.org
Subject: Re: [PATCH 17/39] clobber rbx in putuser_64.S
References: <1214602486-17080-11-git-send-email-gcosta@redhat.com> <1214602486-17080-12-git-send-email-gcosta@redhat.com> <1214602486-17080-13-git-send-email-gcosta@redhat.com> <1214602486-17080-14-git-send-email-gcosta@redhat.com> <1214602486-17080-15-git-send-email-gcosta@redhat.com> <1214602486-17080-16-git-send-email-gcosta@redhat.com> <1214602486-17080-17-git-send-email-gcosta@redhat.com> <1214602486-17080-18-git-send-email-gcosta@redhat.com> <87abh5pxl6.fsf@basil.nowhere.org> <4869497B.5040100@redhat.com> <20080630234504.GA3029@one.firstfloor.org>
In-Reply-To: <20080630234504.GA3029@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> But for this case, I think we can come up with a macro that selects the 
>> appropriate register for each of them. Should be easy to do now that the 
>> code is merged.
> 
> Note that each get_user() backend is ~10 lines or so. If you add
> that many macros you might end up with more code than if you 
> just keep them separate.
> 
> While I admit I am also partly to blame for some asm macro
> mess, e.g. in entry.S, I relented and would now advocate
> to minimize macro use in assembler. It simply makes it much
> harder to understand and to change.
> 
> -Andi
> 

As it turns out, neither seem significant.


4991509	 618198	 475308	6085015	 5cd997	vmlinux
4989760	 618038	 475308	6083106	 5cd222	vmlinux.top
4989392	 618038	 475308	6082738	 5cd0b2	vmlinux.patched


vmlinux is base before integration, .top is the top of my tree, and 
.patched, with the r8 patch added.

As you can see, there _is_ a difference in code size, but not 
significant by any means.

clobbering r8 instead of rbx (.patched vs .top) gives us no
more difference than 0.007 %. Hard to say it matters.

The whole series, gives us a .03 % improvement in code size already 
(although it was not my intention).

So I'd go for leaving the tree as is, clobbering rbx anyway.
