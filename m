Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab0CCMLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 07:11:31 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:34833 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab0CCML1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 07:11:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FO1QB3UiyxCqmgt5cGm5MMzoAZkL80zgh/tkhAKs9T6jp5pl1usFnqo+q1CqTucCwO
         dw1/tRgzEnw3HmITCZtlOzm0nXDKfcQxLwxThi62Nw9/W1cadG8LEa2g8kniixQH9aP8
         mh4mH9G4AX0O5InAIreS656avwTHzOw9mtZ60=
MIME-Version: 1.0
In-Reply-To: <4B3F8896E1733D4787DDB0EA1C7FF91F01163E1D@ukmail.uk.wirelessworld.airvananet.com>
References: <4B3F8896E1733D4787DDB0EA1C7FF91F01163E1D@ukmail.uk.wirelessworld.airvananet.com>
Date: Wed, 3 Mar 2010 14:11:24 +0200
Message-ID: <413a6a951003030411y2c11c6eaj551c26e1bed3679d@mail.gmail.com>
Subject: Re: do_loop_readv_writev() not as described for drivers implementing 
	only write()?
From: Daniel Baluta <daniel.baluta@gmail.com>
To: Mike McTernan <mmcternan@airvana.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 2, 2010 at 2:55 PM, Mike McTernan <mmcternan@airvana.com> wrote:
> Hi,
>
> I'm using writev() with an old FPGA driver which only implements
> write(), not aio_write().  I'm expecting the behaviour described in the
> man page for writev():
>
> "The  data  transfers  performed by readv() and writev() are atomic: the
> data written by writev() is written as a single block that is not
> intermingled with output from writes in other processes (but see pipe(7)
> for an exception); analogously, readv() is guaranteed to read a
> contiguous block of data from the file, regardless of read operations
> performed in other threads or processes that have file descriptors
> referring to the same open file description (see open(2))."
>
> I appear to be observing intermingling of individual iovec entries that
> are being written to the same fd from different threads i.e. each call
> to writev() isn't producing a contiguous block to be output.  This is at
> odds with the man page description.
>
> Looking into the kernel sources (from around 2.6.28 to 2.6.33), the
> driver doesn't implement aio_write(), so vfs_writev() gets handled by
> do_loop_readv_writev() as a series of discrete calls to the driver's
> write().
>
> I can't see where any locking is applied to ensure each iovec is handled
> serially without 'internmingling', which would awkwardly have to be
> outside the driver in this case.

I'm also interested about this topic. Can anyone help?
I would say that the libc enforces atomicity, but I have to dig deeper for
a real answer :).

thanks,
Daniel.
