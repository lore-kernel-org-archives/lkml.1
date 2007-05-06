Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbXEFH3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbXEFH3h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 03:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331AbXEFH3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 03:29:37 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:19807 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307AbXEFH3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 03:29:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fS22TVJR1rlgP9ZHtKxS+Sct509T38YcMHWSmW5fGMF5xmSq4/uhGRRi30Q/FcSdBp9axo2OWNKcgxSu4+P1f5stiG9i6GR1yHaQHzImztf1Wss19EzY35QZ39IkgVLu+yRbj+daJFDN9oNdFGflRDHhlP5xGw/qcu0wO4CtE7c=
Message-ID: <5486cca80705060029p433c6acar22faaeced2d7da37@mail.gmail.com>
Date: Sun, 6 May 2007 09:29:35 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible bug]
Cc: "Oliver Neukum" <oliver@neukum.org>, "Paul Fulghum" <paulkf@microgate.com>,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20070505225241.54a5d01d@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
	 <1178381287.3379.8.camel@x2>
	 <20070505173647.544f6707@the-village.bc.nu>
	 <200705052007.16742.oliver@neukum.org>
	 <20070505225241.54a5d01d@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/5/5, Alan Cox <alan@lxorguk.ukuu.org.uk>:
> On Sat, 5 May 2007 20:07:15 +0200
> Oliver Neukum <oliver@neukum.org> wrote:
[cut]
> > should I understand this so that, if tty_buffer_request_room() returns
> > less than requested, the rest of the data should be dropped on the
> > floor?
>
> If it returns NULL then either there is > 64K buffered (we can adjust
> that if anyone shows need - its just for sanity) or the system is out of
> RAM.

For my use case would be more sensible to accept the new data and
discard the older one in the tty buffer: the tty buffer would be a
moving window of the most recent incoming data. This because if
someone does not read the incoming data maybe he's not interested in
it. When he finally reads the data (assuming there was buffer
underrun) he's likely interested to the more recent chunk of incoming
data and not to an "head" of the data firstly received. Since I
acquire measurement data from serial this make perfect sense for me.
But does this make sense in general too?

However, whatever policy the buffer uses, the fundamental point it's that
when I flush the input buffer I should be sure that each byte read
after the flush is *new* (current) data and not old one. This because
when the input stream can be stopped I can check that there are 0 byte
in the buffer, but when the stream can't be stopped I must use a
flush-and-sleep (multiple times) heuristic before I can read a single
*reliable* byte.

> Alan
>

Regards,

  ~ Antonio
