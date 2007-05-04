Return-Path: <linux-kernel-owner+w=401wt.eu-S1161441AbXEDJdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161441AbXEDJdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 05:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161608AbXEDJdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 05:33:14 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:34204 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161441AbXEDJdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 05:33:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Q+seoju1832dbicbZEeIUt1la4bE0RPej6wOBNCLdy/Yq0ZHmuXED1/rKmQieLsVIxehV/dOc9qbpA/0iedJLHewJoqPXJNF5VwrU3x0UiJnFxbjU4kJG8ErvqEcjRxQ/O/G2L6dNKVkwF/YN/ma47QXmiZgWhNLYz6GXtcKsuY=
Message-ID: <5486cca80705040233y70915a27yf7cbbc08a617e3ba@mail.gmail.com>
Date: Fri, 4 May 2007 11:33:13 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible bug]
In-Reply-To: <5486cca80705040229g53933671m658bd028cadca155@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
	 <200705041049.20989.oliver@neukum.org>
	 <5486cca80705040229g53933671m658bd028cadca155@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Accidentally I've replied privately, sorry. Forwarding to ML...

---------- Forwarded message ----------
From: Antonino Ingargiola <tritemio@gmail.com>
Date: May 4, 2007 11:29 AM
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI
usb-serial possible bug]
To: Oliver Neukum <oliver@neukum.org>


On 5/4/07, Oliver Neukum <oliver@neukum.org> wrote:
> Am Freitag, 4. Mai 2007 10:38 schrieb Antonino Ingargiola:
> > To solve the problem we must do a complete flush of all the buffer
> > chain. I do this flushing the input multiple times with a small pause
> > between them. In my case 10 flushes separated by a 10ms pause always
> > empties the whole buffer chain, so I get no corruption anymore. I'ts
> > not an elegant solution but it works (10 flushes are an overkill but I
> > want to be _really_ sure to read the correct data).
>
> How do you flush the buffers? Simply reading them out?

Nope. In python I use the flushInput() method of the serial object
defined by the pyserial library[0]. The method does just this system
call:

    termios.tcflush(self.fd, TERMIOS.TCIFLUSH)

that I think is correct.

Cheers,

  ~ Antonio

[0]: http://pyserial.sourceforge.net/ (or python-serial debian package)
