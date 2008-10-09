Return-Path: <linux-kernel-owner+w=401wt.eu-S1758488AbYJIGam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488AbYJIGam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 02:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbYJIGab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 02:30:31 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:12514 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbYJIGab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 02:30:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mtsfUX3W2ZJth06T6Hn1BdX5DV3SVCM5E4avveoNyYUNRdc0DGZkIkC2ZBdaBc3nTA
         E74LhyLgpjs9RTlC3OJTZu+NyQ4zmJ2KsEz1+BYJnERBIiUNN6+WOTkb/Aa9FkDlyMox
         nnLaTulnka0UIyPPKfwOrwcL0YevqiPATlvOY=
Message-ID: <cabda6420810082330i6d013e18o72eac3cb869b1e4e@mail.gmail.com>
Date: Thu, 9 Oct 2008 08:30:28 +0200
From: chri <chripell@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] max3100 driver
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
In-Reply-To: <20080920151149.21dbad1d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221895208650-git-send-email-chripell@gmail.com>
	 <20080920151149.21dbad1d@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2008 at 4:11 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> +#define MAX3100_MAJOR 204
>> +#define MAX3100_MINOR 128
>> +/* 4 MAX3100s should be enough for everyone */
>> +#define MAX_MAX3100 4
>
> These need to be officially allocated if you need constant numbers
>

done, I followed the guide in devices.txt

>> +
>> +     etx = htons(tx);
>
> Use cpu_to_le/be or le/be_to_cpu functions, these make the intended
> endianness clear.
>
>> +     *rx = ntohs(erx);
>
> Ditto
>

done

>> +             if (rxchars > 0)
>> +                     tty_flip_buffer_push(s->port.info->port.tty);
>> +             if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
>
> If there has been a hangup the port.tty will be NULL...
>

I check against NULL. But let me ask again: the other drivers (for
example SA1100) don't do it. How they avoid the nasty NULL pointer
dereference?

>> +static void
>> +max3100_set_termios(struct uart_port *port, struct ktermios *termios,
>> +                struct ktermios *old)
>> +{
>> +     struct max3100_port_s *s = container_of(port,
>> +                                             struct max3100_port_s,
>
>> +     if (!old || (termios->c_cflag != old->c_cflag)) {
>
> This optimisation is wrong and not worth doing anyway
>

done

>
> Bits you don't support should also be cleared in the tty->termios struct
> (eg markspace you don't seem to do)
>
>

done, I completely rewrote termios handling following Alan instructions.

>> +     max3100s[i] = kzalloc(sizeof(struct max3100_port_s), GFP_KERNEL);
>> +     if (!max3100s[i]) {
>> +             dev_warn(&spi->dev,
>> +                      "kmalloc for max3100 structure %d failed!\n", i);
>
> Does this not then need to unregister the driver ?
>
>

I think no: perhaps it's just the probe of the second MAX3100 port
that failed so we cannot unegister the driver. And the user can try to
reprobe the MAX3100 via the bind entry. As I see it: driver
registration and port registration are 2 different things.

>
> Looks basically sound to me - just some minor cleanups needed.
>
> Alan
>

Sorry again for not having replied before resending the patch.


-- 
Christian Pellegrin, see http://www.evolware.org/chri/
"Real Programmers don't play tennis, or any other sport which requires
you to change clothes. Mountain climbing is OK, and Real Programmers
wear their climbing boots to work in case a mountain should suddenly
spring up in the middle of the computer room."
