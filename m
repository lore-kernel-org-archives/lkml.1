Return-Path: <linux-kernel-owner+w=401wt.eu-S1751717AbZHJTIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbZHJTIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 15:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbZHJTIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 15:08:31 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:56109 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbZHJTIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 15:08:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=PiEVUQX95/WCO5oSyHNxLMw4vS60n3b73ugmaApU44RrgWY/htlcAkr5e2HXR9InkM
         QcITY3LT2L5WqrqgOSdFM0lvejNbSK1JoTppjjHF0oGiDX97nflzVvFNMkJAOVzlLEFQ
         rfM9TA+/WiJ36huVwubVA/V27iMEVdXzSRkVI=
Message-ID: <4A80702D.20701@gmail.com>
Date: Mon, 10 Aug 2009 21:08:29 +0200
From: Artur Skawina <art.08.09@gmail.com>
User-Agent: Thunderbird 2.0.0.22pre (X11/20090422)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ray Lee <ray-lk@madrabbit.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: xterm loses data (pty regression)
References: <4A803CE7.20201@gmail.com> <2c0942db0908101007t54c39b64k2800b2c320969318@mail.gmail.com> <alpine.LFD.2.01.0908101016100.3288@localhost.localdomain> <alpine.LFD.2.01.0908101105040.3602@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0908101105040.3602@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
>> (Do ^S/^Q, see data loss)

> I think it's really this trivial.
> 
> That pty commit removed the checking for tty->stopped in 
> pty_write_buffer() for no clear reason. And when it did that, it broke all 
> the pausing logic in drivers/char/n_tty.c.
> 
> Can you confirm?

>  static int pty_write_room(struct tty_struct *tty)
>  {
> +	if (tty->stopped)
> +		return 0;
>  	return pty_space(tty->link);
>  }

w/ this, the pty writes now block again after ^Q, and the data loss is gone.

Thanks,

artur
