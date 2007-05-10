Return-Path: <linux-kernel-owner+w=401wt.eu-S1762773AbXEJV4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762773AbXEJV4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 17:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757268AbXEJV43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 17:56:29 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52632 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755932AbXEJV42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 17:56:28 -0400
Date: Thu, 10 May 2007 23:00:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] "volatile considered harmful" document
Message-ID: <20070510230003.5861c4b9@the-village.bc.nu>
In-Reply-To: <46437416.4070401@zytor.com>
References: <25493.1178744744@lwn.net>
	<46437416.4070401@zytor.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> In Ethernet drivers, for example, it is common for the network card to
> maintain a pointer in host memory the the latest descriptor written; you
> will generally have a loop of the form:
> 
> 	while ((this_pointer = *pointer_ptr) > my_last_pointer) {
> 		for (pkt = my_last_pointer; pkt < this_pointer; pkt++)
> 			receeive_packet(pkt);
> 		my_last_pointer = this_pointer;
> 	}
> 
> pointer_p can then be a volatile pointer into said coherent memory.

True but you can happily use rmb/wmb for this which are clearer and fit
the rest of the Linux model better.

Alan
