Return-Path: <linux-kernel-owner+w=401wt.eu-S1759426AbXEJTj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426AbXEJTj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759413AbXEJTjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:39:16 -0400
Received: from terminus.zytor.com ([192.83.249.54]:36188 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759288AbXEJTjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:39:14 -0400
Message-ID: <46437416.4070401@zytor.com>
Date: Thu, 10 May 2007 12:35:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] "volatile considered harmful" document
References: <25493.1178744744@lwn.net>
In-Reply-To: <25493.1178744744@lwn.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet wrote:
> OK, here's an updated version of the volatile document - as a plain text
> file this time.  It drops a new file in Documentation/, but might it be
> better as an addition to CodingStyle?
> 
> Comments welcome,

I have found one use of volatile which I consider legitimate: pointers
to data structures read or written by I/O devices in coherent memory
(typically pci_coherent memory.)  This is local to device drivers, but
as far as I can tell, the use of volatile here is legitimate, although
arguably it will be redundant in > 90% of all cases due to the
incidental presence of other memory barriers.

In Ethernet drivers, for example, it is common for the network card to
maintain a pointer in host memory the the latest descriptor written; you
will generally have a loop of the form:

	while ((this_pointer = *pointer_ptr) > my_last_pointer) {
		for (pkt = my_last_pointer; pkt < this_pointer; pkt++)
			receeive_packet(pkt);
		my_last_pointer = this_pointer;
	}

pointer_p can then be a volatile pointer into said coherent memory.

	-hpa

		
