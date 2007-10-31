Return-Path: <linux-kernel-owner+w=401wt.eu-S1757089AbXJaJGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089AbXJaJGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 05:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbXJaJG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 05:06:29 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:58393 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbXJaJG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 05:06:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Dct7MYFuMy7/BFum78vFG9TekKTy1DuxTaFCS9ui3H1uFtfn7/mEaVG3B739SL4RMbuGfAHaB0+KzYq35jcPK6Xslq9LEleroXXIZ3mheEOjS8CldMbVjqXtZOkhHQbuUo7iJfzFOtglAu047lhFA9SKMhpfpkcnx0Jb1hHTvRg=
Message-ID: <a8e1da0710310206j1b3571f9rf4074f55f9024b94@mail.gmail.com>
Date: Wed, 31 Oct 2007 17:06:27 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH]bluetooth: hci_sysfs connection bus_id add support for diffrent hci device
Cc: marcel@holtmann.org, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net
In-Reply-To: <20071031.000141.241824894.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071031023017.GA3896@darkstar.te-china.tietoenator.com>
	 <20071031.000141.241824894.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/07, David Miller <davem@davemloft.net> wrote:
> From: Dave Young <hidave.darkstar@gmail.com>
> Date: Wed, 31 Oct 2007 10:30:17 +0800
>
> > diff -upr linux/net/bluetooth/hci_sysfs.c linux.new/net/bluetooth/hci_sysfs.c
> > --- linux/net/bluetooth/hci_sysfs.c   2007-10-31 10:21:00.000000000 +0800
> > +++ linux.new/net/bluetooth/hci_sysfs.c       2007-10-31 10:21:55.000000000 +0800
> > @@ -302,7 +302,8 @@ void hci_conn_add_sysfs(struct hci_conn
> >       conn->dev.release = bt_release;
> >
> >       snprintf(conn->dev.bus_id, BUS_ID_SIZE,
> > -                     "%s%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X",
> > +                     "%s%s%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X",
> > +                     hdev->name,
> >                       conn->type == ACL_LINK ? "acl" : "sco",
> >                       ba->b[5], ba->b[4], ba->b[3],
> >                       ba->b[2], ba->b[1], ba->b[0]);
>
> This might not work.
>
> Your device's name is already 15 characters long,
> BUS_ID_SIZE is 20, and it seems hdev->name could
> easily overflow the 4 or 5 characters of space
> remaining.
>
Yes, this is possible due to hdev->name length is 8.

The space for it ist 5 characters. IMHO,in normal usage 'hciX' is
unlikely over this limit.

Any better ideas?
