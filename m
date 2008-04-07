Return-Path: <linux-kernel-owner+w=401wt.eu-S1758230AbYDGNui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbYDGNui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 09:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbYDGNu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 09:50:29 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:35642 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbYDGNu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 09:50:29 -0400
Message-ID: <47FA26A0.3020701@codemonkey.ws>
Date: Mon, 07 Apr 2008 08:50:24 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.virtualization
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Balaji Rao <balajirrao@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio: remove overzealous BUG_ON.
References: <200804071430.28399.rusty__35361.6672721275$1207542780$gmane$org@rustcorp.com.au>
In-Reply-To: <200804071430.28399.rusty__35361.6672721275$1207542780$gmane$org@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> The 'disable_cb' callback is designed as an optimization to tell the host
> we don't need callbacks now.  As it is not reliable, the debug check is
> overzealous: it can happen on two CPUs at the same time.  Document this.
> 
> Even if it were reliable, the virtio_net driver doesn't disable
> callbacks on transmit so the START_USE/END_USE debugging reentrance
> protection can be easily tripped even on UP.
> 
> Thanks to Balaji Rao for the bug report and testing.

I think the printk() in start_xmit should be removed too (or at least 
rate limited).

Regards,

Anthony Liguori
