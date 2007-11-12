Return-Path: <linux-kernel-owner+w=401wt.eu-S1756354AbXKLPPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354AbXKLPPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 10:15:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbXKLPOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 10:14:50 -0500
Received: from palrel11.hp.com ([156.153.255.246]:36477 "EHLO palrel11.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbXKLPOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 10:14:49 -0500
Message-ID: <47386DE6.4020207@hp.com>
Date: Mon, 12 Nov 2007 10:14:46 -0500
From: Vlad Yasevich <vladislav.yasevich@hp.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: lksctp developers <lksctp-developers@lists.sourceforge.net>,
       netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sridhar Samudrala <sri@us.ibm.com>
Subject: Re: [Lksctp-developers] [PATCH] Fix memory leak in discard case of
 sctp_sf_abort_violation()
References: <200711112357.49577.jesper.juhl@gmail.com>
In-Reply-To: <200711112357.49577.jesper.juhl@gmail.com>
X-Enigmail-Version: 0.95.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> From: Jesper Juhl <jesper.juhl@gmail.com>
> 
> In net/sctp/sm_statefuns.c::sctp_sf_abort_violation() we may leak 
> the storage allocated for 'abort' by returning from the function 
> without using or freeing it. This happens in case 
> "sctp_auth_recv_cid(SCTP_CID_ABORT, asoc)" is true and we jump to 
> the 'discard' label.
> Spotted by the Coverity checker.
> 
> The simple fix is to simply move the creation of the "abort chunk" 
> to after the possible jump to the 'discard' label. This way we don't   
> even have to allocate the memory at all in the problem case.
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

Thanks.  I've applied this to my tree.

-vlad
