Return-Path: <linux-kernel-owner+w=401wt.eu-S1758471AbZJEDkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471AbZJEDkP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 23:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758440AbZJEDkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 23:40:14 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:41562 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758424AbZJEDkN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 23:40:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=IbKwXBfMd+pAs1dgDbMfF+S35ND6uZ/KLTT4vZiZK28Fd+kYGscrsOThlj/iQc6EsG
         HaLpzM7VAW3a57CSTsGXkpR6JOvf3bbcV//YqRdeLhozZkSGvCi6PBR9x1A1WigmNr4m
         XPeJCBIfalzw8plbusZ9OHu5r8KmA3CTDAOKo=
MIME-Version: 1.0
In-Reply-To: <20091005122551.5F8F.A69D9226@jp.fujitsu.com>
References: <20091005114236.5F8C.A69D9226@jp.fujitsu.com> <3e8340490910042022y6182414bg5bfb10b8a3100c4@mail.gmail.com> 
	<20091005122551.5F8F.A69D9226@jp.fujitsu.com>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Sun, 4 Oct 2009 23:39:12 -0400
Message-ID: <3e8340490910042039x54e175e7g48ec4fec2dfec6e1@mail.gmail.com>
Subject: Re: [PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Timo Sirainen <tss@iki.fi>,
       linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 4, 2009 at 11:29 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> On Sun, Oct 4, 2009 at 10:48 PM, KOSAKI Motohiro
>> <kosaki.motohiro@jp.fujitsu.com> wrote:
>>
>> > +                       } else {
>> > +                               len = mm->env_end - mm->env_start;
>> > +                               if (len > PAGE_SIZE - res)
>> > +                                       len = PAGE_SIZE - res;
>> > +                               res += access_process_vm(task, mm->env_start,
>> > +                                                        buffer+res, len, 0);
>> > +                               res = strnlen(buffer, res);
>> > +                       }
>>
>>
>> This bug was in the original code, but since you're touching it
>> anyway, it should be fixed now; if this access_process_vm fails
>> (perhaps due to the target unmapping the page in question in between
>> the two calls), bad things might happen if (error code) + res < 0, as
>> then strnlen will get a huge value in its length (possibly leading to
>> OOPS etc). It should be changed to check for an error return here and
>> fail out properly if there is an error in this second check.
>
> AFAIK, access_process_vm() never return negative value.

Ahh, okay, I had read the if (res > 0 && ...) bit in the original code
as an error test. Nevermind then.
