Return-Path: <linux-kernel-owner+w=401wt.eu-S1765390AbXHHNPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765390AbXHHNPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 09:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759136AbXHHNPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 09:15:23 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:35969
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758034AbXHHNPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 09:15:22 -0400
Message-ID: <46B9CF8D.1000209@microgate.com>
Date: Wed, 08 Aug 2007 08:13:33 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Laurent Pinchart <laurentp@cse-semaphore.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Serial buffer memory leak
References: <200708081158.06843.laurentp@cse-semaphore.com>
In-Reply-To: <200708081158.06843.laurentp@cse-semaphore.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Pinchart wrote:
> Patch c5c34d4862e18ef07c1276d233507f540fb5a532 (tty: flush flip buffer on 
> ldisc input queue flush) introduces a race condition which can lead to memory 
> leaks.
> 
> The problem can be triggered when tcflush() is called when data are being 
> pushed to the line discipline driver by flush_to_ldisc().
> 
> flush_to_ldisc() releases tty->buf.lock when calling the line discipline 
> receive_buf function. At that poing tty_buffer_flush() kicks in and sets both 
> tty->buf.head and tty->buf.tail to NULL. When flush_to_ldisc() finishes, it 
> restores tty->buf.head but doesn't touch tty->buf.tail. This corrups the 
> buffer queue, and the next call to tty_buffer_request_room() will allocate a 
> new buffer and overwrite tty->buf.head. The previous buffer is then lost 
> forever without being released.

Your description is clear enough, I'll make the patch.

Thanks,
Paul
