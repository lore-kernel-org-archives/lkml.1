Return-Path: <linux-kernel-owner+w=401wt.eu-S1755438AbZB1VtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbZB1VtU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 16:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbZB1VtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 16:49:09 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:34289 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbZB1VtH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 16:49:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TvPJ9JphyHOFFmgSOTznvmlCQ94HVdZ38PmTamt+lIPrgEiDrjfDTTg/bJ/eEXMPDX
         A4XFnXNW9kmQv7EKFj0lWuJ4qIvhhorErSg47TjMvA5BeZvs61BdAdXJQjUSAy6dIcIe
         iiXsmUEi7+tZAQUofs0vmd+QYiJnohOIRjNoA=
MIME-Version: 1.0
In-Reply-To: <1235856798.6074.34.camel@localhost.localdomain>
References: <1235797347-1816-1-git-send-email-gustavo@las.ic.unicamp.br>
	 <1235856798.6074.34.camel@localhost.localdomain>
Date: Sat, 28 Feb 2009 18:49:02 -0300
X-Google-Sender-Auth: f2e4ae2b2530a07d
Message-ID: <6b53b1990902281349m2c2ed590h6264863ce415b7af@mail.gmail.com>
Subject: Re: [PATCH 1/3] bluetooth: add write_lock_bh to __l2cap_chan_link
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 6:33 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Gustavo,
>
>> fix race condition
>>
>> Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
>> ---
>>  net/bluetooth/l2cap.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/bluetooth/l2cap.c b/net/bluetooth/l2cap.c
>> index ca4d3b4..355f375 100644
>> --- a/net/bluetooth/l2cap.c
>> +++ b/net/bluetooth/l2cap.c
>> @@ -175,12 +175,14 @@ static inline void __l2cap_chan_link(struct l2cap_chan_list *l, struct sock *sk)
>>  {
>>       sock_hold(sk);
>>
>> +     write_lock_bh(&l->lock);
>>       if (l->head)
>>               l2cap_pi(l->head)->prev_c = sk;
>>
>>       l2cap_pi(sk)->next_c = l->head;
>>       l2cap_pi(sk)->prev_c = NULL;
>>       l->head = sk;
>> +     write_unlock_bh(&l->lock);
>>  }
>
> a general rule of thumb is that function starting with __ are the ones
> that don't use any kind of locking.

Ok. I noted this after send the patch. :-(

>
> Regards
>
> Marcel
>
>
>



-- 
Gustavo F. Padovan

Computer Engineering Student
Institute of Computing - IC
University of Campinas - UNICAMP

email: gustavo@las.ic.unicamp.br
gtalk: gfpadovan@gmail.com
mobile: +55 19 81030803
