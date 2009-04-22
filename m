Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbZDVQR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbZDVQR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 12:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755595AbZDVQRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 12:17:36 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:42545 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552AbZDVQRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 12:17:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qRJHMhAlDIQ5WLX2MmMLRBtrDQeMvvH7xh0pDpEvywagtcUFYC/e2OElNJh3SRt6qB
         CBUdx8Vyyc8SXVanXHmNes4Dt2Ragc2iaYnnAfpRkfT5dbdo5+DVths5qZ6xdM5Maac/
         3LgYcLNeroc7oHFpExjXhX+q1NE5Ewx6oEZMM=
MIME-Version: 1.0
In-Reply-To: <20090422145050.C00333780DD@ns.ariel-networks.com>
References: <20090422145050.C00333780DD@ns.ariel-networks.com>
Date: Wed, 22 Apr 2009 18:17:32 +0200
Message-ID: <4e5e476b0904220917p38be0cb3t665b11fe3ac7d765@mail.gmail.com>
Subject: Re: Question : internal processing of block I/O queue
From: Corrado Zoccolo <czoccolo@gmail.com>
To: ohyama_sec@ariel-networks.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I think you should read: Documentation/block/barrier.txt
Without explicitly asking for barriers, block I/O doesn't guarantee
FIFO ordering (or any other ordering), since it would be too
inefficient on some devices.

Corrado


On Wed, Apr 22, 2009 at 4:50 PM,  <ohyama_sec@ariel-networks.com> wrote:
> From: Hiroyasu OHYAMA
>
> I'm a student of Japan, and I diddle the Linux for joyment.
> Could I ask you a question about block I/O.
>
> The question is that "Does The linux block I/O processing follow a first-in first-out order"
>
> Now, I'm making layer under low level filesystem. And I wonna make it work as Cache of data like page cache.
> I could understood if I emit block I/O request with submit_bio(), the kernel delay it, and I could notice the result by .bi_end_io() method that I set.
>
> But I have something on my mind. "Does the kernel assure the order of block I/O ?"
>
> Once I issue a block I/O request to common I/O layer, the I/O processing is delayed. And the actual block I/O processing is executed by kernel thread.
> So user who commit block I/O never have to mind the sequence of delayed block I/O requests.
> But I want to know that "The block I/O processing executed first is executed earlient, or may not".
>
> If a I/O request issued back is issued earlier than before, I have to protect the target block that is issued block I/O request.
>
> Could you please give me the actuall operation of block I/O component, that is "It may happen, or not".
>
> Thank you in advance.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
