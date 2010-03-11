Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab0CKDKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 22:10:34 -0500
Received: from mail-qy0-f204.google.com ([209.85.221.204]:62560 "EHLO
	mail-qy0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab0CKDKd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 22:10:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DpCCdLa9K+wcGbDJUx6S34kvZG9CMjO4VesyqQ0C5M3BS3n4GBtPOA7ylANeKl6Tii
         EF2v6Aelie+qI3VE6dYUP2Z+6dAENGPfaH6yL3ShPyDIfg3e2k3g5OuTYuYhUP4JgknM
         yL9QgI2/apqgQBiGshxu7k53r2gOBxmmgMlMk=
MIME-Version: 1.0
In-Reply-To: <20100310103409.GA7451@localhost2.local>
References: <20100310103409.GA7451@localhost2.local>
Date: Thu, 11 Mar 2010 11:10:31 +0800
Message-ID: <7b6bb4a51003101910n27a85bb7jf693c1f8e51ee392@mail.gmail.com>
Subject: Re: 'struct uart_port' has no member named 'info
From: Xiaotian Feng <xtfeng@gmail.com>
To: rogerx@sdf.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 6:34 PM,  <rogerx@sdf.org> wrote:
> Upgraded from kernel-2.6.32 to kernel-2.6.33, and now get the following
> error when compiling ltmodem.
>
> I checked for changes within drivers/serial/serial_core.c, but couldn't
> find the specific change.  (I did verify ltmodem compiles fine without
> error under 2.6.32.)
>

uart_port->info has been removed by commit
ebd2c8f6d2ec4012c267ecb95e72a57b8355a705
I think s/info/state can solve your build issue.

>
> /var/tmp/portage/net-dialup/ltmodem-20090420/work/ltmodem/v8250.c: In
> function 'receive_chars':
> /var/tmp/portage/net-dialup/ltmodem-20090420/work/ltmodem/v8250.c:181:
> error: 'struct uart_port' has no member named 'info'
> /var/tmp/portage/net-dialup/ltmodem-20090420/work/ltmodem/v8250.c: In
> function 'transmit_chars':
> /var/tmp/portage/net-dialup/ltmodem-20090420/work/ltmodem/v8250.c:243:
> error: 'struct uart_port' has no member named 'info'
> /var/tmp/portage/net-dialup/ltmodem-20090420/work/ltmodem/v8250.c: In
> function 'check_modem_status':
> /var/tmp/portage/net-dialup/ltmodem-20090420/work/ltmodem/v8250.c:284:
> error: 'struct uart_port' has no member named 'info'
> /var/tmp/portage/net-dialup/ltmodem-20090420/work/ltmodem/v8250.c:294:
> error: 'struct uart_port' has no member named 'info'
> make[2]: ***
> [/var/tmp/portage/net-dialup/ltmodem-20090420/work/ltmodem/v8250.o]
> Error 1
>
>
> --
> Roger
> http://rogerx.freeshell.org/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
