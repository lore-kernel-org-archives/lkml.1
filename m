Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbYLYSUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbYLYSUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 13:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbYLYSUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 13:20:04 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55854 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbYLYSUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 13:20:02 -0500
Message-ID: <4953CECE.5050900@redhat.com>
Date: Thu, 25 Dec 2008 20:19:58 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joerg.roedel@amd.com>,
       Benjamin Serebrin <benjamin.serebrin@amd.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       Alexander Graf <agraf@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Re: kvm vmload/vmsave vs tss.ist
References: <49539FD0.7070103@redhat.com> <20081225151757.GA25117@elte.hu> <4953AAE5.4000708@redhat.com> <20081225162107.GB14486@elte.hu> <20081225164232.GA25195@elte.hu> <4953C57F.70502@redhat.com> <20081225175821.GA23390@elte.hu> <4953CD1A.5090906@redhat.com>
In-Reply-To: <4953CD1A.5090906@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>
> I'm suggesting
>
>    check irqcount
>    if (wasnt_in_irq)
>        rsp = irqstack
>    ++irqcount
>
> If the NMI happens before the increment, we'll switch the stack 
> unconditionally, and if the NMI happens after the increment, then we 
> won't switch the stack, but we're guaranteed to be on the irqstack 
> anyway.  The window size is negative :)
>
> Similarly, the exit path should be
>
>    oldstack_reg = oldstack;
>    --irqcount;
>    rsp = oldstack_register;
>
> To guarantee that by the time we decrement irqcount, we don't need the 
> stack anymore.
>

On the other hand, checking %rsp allows us to drop irqcount completely, 
so maybe it's better.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

