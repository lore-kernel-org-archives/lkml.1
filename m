Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbYITKfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbYITKfh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 06:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbYITKf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 06:35:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:18918 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbYITKf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 06:35:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uVwGzgWw3NS79CGTHV/BW09F1j8lFFUtUagBGEDznZ1oL60T+t4OL8r9Dhgtu+CLpv
         2fvqgfDlD2D5Beo36V4zs0rKXtAAvakj4sbWWVWNoYtROdY4D9qKj57L3WsfAUIkT+K3
         9PnIzPm9loWxolTa5utDm3SeT2/wD4S95DRUg=
Message-ID: <cabda6420809200335x3409d31eo47e7aa5fc809cfa4@mail.gmail.com>
Date: Sat, 20 Sep 2008 12:35:26 +0200
From: chri <chripell@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] max3100 driver
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
In-Reply-To: <20080920012454.e40f03cc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221895208650-git-send-email-chripell@gmail.com>
	 <20080920012454.e40f03cc.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, sent HTML mail by mistake, so resending :-/


On Sat, Sep 20, 2008 at 10:24 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:

> > +#define MAX3100_MAJOR 204
>
> Allocating a new major is a Big Deal.  It involves getting the major
> registered by contacting device@lanana.org.
>
> It's better to dynamically allocate it - let udev handle it.
>


I looked at other serial driver as an example and checked devices.txt:
if I don't get it wrong major 204 should be already reserved for
serial port. Anyway I choose a minor number already allocated by
mistake (did not see the "...") and will correct that. Is this ok or I
*have to* move to dynamic major (it's a bit a nuisance since max3100
is used in embedded system where udev is not always used)?


> `struct max3100_port' is sufficient, and would be more typical.
>
> > +     struct uart_port port;
> > +     struct spi_device *spi;
> > +
> > +     int cts:1;              /* last CTS received for flow ctrl */
> > +     int tx_empty:1;         /* last TX empty bit */
>
> These two bits will share a word and hence locking is needed to prevent
> modifications to one from trashing modifications to the other on SMP.
>
> That's OK, but it would be best to document that locking right here, and
> to check that it is adhered to.
>


I did not realize this until you explained me. I'm not sure if actual
packing of bit-fields is implementation dependent but I think so. If
this is right I guess it's better to avoid bit-fields in structs that
can be accessed concurrently (or otherwise I have to lock the entire
struct). So, should I avoid bit-fields altogether?

I will correct the patch and resend.

Thanks,

--
Christian Pellegrin, see http://www.evolware.org/chri/
"Real Programmers don't play tennis, or any other sport which requires
you to change clothes. Mountain climbing is OK, and Real Programmers
wear their climbing boots to work in case a mountain should suddenly
spring up in the middle of the computer room."
