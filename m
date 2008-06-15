Return-Path: <linux-kernel-owner+w=401wt.eu-S1756575AbYFODf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbYFODf1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 23:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755605AbYFODfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 23:35:19 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:25230 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587AbYFODfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 23:35:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=t0hODD67NNe79vYIyqNoLN6okrSreLEMKBEvhGo7O6EHIWgWQaaaD4wcjD0+TT7X1q
         Rz/HM3dFDS7VyH16Uq/PhMz8JnJxpt/geuGeh0aJq8OD9tvnMKmChSd4WV5NrlLdhc5V
         2PFqE//oBR8AsAmaSCZLIdyNPEIXKAeSuO5So=
Message-ID: <a8e1da0806142035i6212a079m151aea73bec34cd6@mail.gmail.com>
Date: Sun, 15 Jun 2008 11:35:15 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
Subject: Re: [patch 16/47] bluetooth: fix locking bug in the rfcomm socket cleanup handling
Cc: "Greg KH" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Michael Krufky" <mkrufky@linuxtv.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Domenico Andreoli" <cavokz@gmail.com>, "Willy Tarreau" <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Arjan van de Ven" <arjan@linux.intel.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Chris Wright" <chrisw@sous-sol.org>
In-Reply-To: <1213446386.17870.146.camel@violet.holtmann.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080613234753.235721454@mini.kroah.org>
	 <20080614000840.GA24659@suse.de> <20080614001058.GP24698@suse.de>
	 <a8e1da0806131950i4eb0ea48q5cc34ea07cfd523a@mail.gmail.com>
	 <1213446386.17870.146.camel@violet.holtmann.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 8:26 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Dave,
>
>> > Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
>> > Acked-by: Marcel Holtmann <marcel@holtmann.org>
>> > Signed-off-by: David S. Miller <davem@davemloft.net>
>> > Signed-off-by: Chris Wright <chrisw@sous-sol.org>
>> > ---
>> >  net/bluetooth/rfcomm/core.c |    2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > --- a/net/bluetooth/rfcomm/core.c
>> > +++ b/net/bluetooth/rfcomm/core.c
>> > @@ -423,8 +423,8 @@ static int __rfcomm_dlc_close(struct rfc
>> >
>> >                rfcomm_dlc_lock(d);
>> >                d->state = BT_CLOSED;
>> > -               rfcomm_dlc_unlock(d);
>> >                d->state_change(d, err);
>> > +               rfcomm_dlc_unlock(d);
>> >
>> >                skb_queue_purge(&d->tx_queue);
>> >                rfcomm_dlc_unlink(d);
>
> did we screw up the tabs during the review process here.

Yes, it's due to my use of gmail web interface.
But please don't worry. I usually post patches by mutt, and reply by
gmail web client to easily quote the original message.
