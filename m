Return-Path: <linux-kernel-owner+w=401wt.eu-S1422941AbXCGRT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422941AbXCGRT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422959AbXCGRTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:19:55 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44401 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422942AbXCGRTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:19:34 -0500
Date: Wed, 7 Mar 2007 18:23:18 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Jon Ringle <JRingle@vertical.com>, linux-kernel@vger.kernel.org
Subject: Re: tiny tty driver sample
Message-ID: <20070307182318.28d95c95@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0703071730190.10909@twin.jikos.cz>
References: <4DD3AF7ECBBC43409BA36508938D0185123A35@CVAEX1.VERTICAL.COM>
	<Pine.LNX.4.64.0703071730190.10909@twin.jikos.cz>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I guess something like
> 
> 	tty_buffer_request_room(tty, data_size);
> 	for (i = 0; i < data_size; ++i)
> 		work += tty_insert_flip_char(tty, data[i], TTY_NORMAL);
> 	if (work)
> 		tty_flip_buffer_push(tty);


Unless data_size can be very large and high speed then you can replace the
lot with

	if (tty_insert_flip_string(tty, data, data_size))
		tty_flip_buffer_push(tty);

