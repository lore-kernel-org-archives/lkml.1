Return-Path: <linux-kernel-owner+w=401wt.eu-S1752126AbXC1OzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbXC1OzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 10:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbXC1OzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 10:55:13 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:37607 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbXC1OzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 10:55:12 -0400
Subject: Re: question on tty open and close
From: Marcel Holtmann <marcel@holtmann.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Paul Fulghum <paulkf@microgate.com>,
       Stuart MacDonald <stuartm@connecttech.com>,
       "'Oliver Neukum'" <oliver@neukum.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070328163158.658b372a@the-village.bc.nu>
References: <200703281516.31366.oliver@neukum.org>
	 <019201c7713c$1a3277c0$294b82ce@stuartm>
	 <20070328154439.40ca5c3c@the-village.bc.nu>
	 <460A8941.4090405@microgate.com>
	 <20070328163158.658b372a@the-village.bc.nu>
Content-Type: text/plain
Date: Wed, 28 Mar 2007 16:54:41 +0200
Message-Id: <1175093681.5815.145.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

> > As long as the new behavior continues to call
> > driver->close() if driver->open() succeeds
> > then I see no problem.
> 
> It breaks if any existing driver is doing no cleanup in ->open() when it
> fails but relying upon ->close() being called. That is what needs
> auditing first of all.

I know at least that the Bluetooth TTY emulation (RFCOMM) will break
since I have a big fat warning in my code:

        /* We don't leak this refcount. For reasons which are not entirely
           clear, the TTY layer will call our ->close() method even if the
           open fails. We decrease the refcount there, and decreasing it
           here too would cause breakage. */
        dev = rfcomm_dev_get(id);
        if (!dev)
                return -ENODEV;

Regards

Marcel


