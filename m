Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552Ab0CNRCv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 13:02:51 -0400
Received: from posthamster.phnxsoft.com ([195.227.45.4]:2234 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759519Ab0CNRCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 13:02:48 -0400
X-Greylist: delayed 1347 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Mar 2010 13:02:48 EDT
Message-ID: <4B9D10D1.1060602@phoenixsoftware.de>
Date: Sun, 14 Mar 2010 17:37:37 +0100
From: Tilman Schmidt <t.schmidt@phoenixsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: should new kfifo implementation really be exporting that much?
References: <alpine.LFD.2.00.1003140929350.4644@localhost> <alpine.LFD.2.00.1003141053380.5987@localhost>
In-Reply-To: <alpine.LFD.2.00.1003141053380.5987@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Spam-Score: 0.101 () BAYES_50,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.03.2010 15:57 schrieb Robert P. J. Day:
>   as a short followup, kfifo.h strongly implies that a lot of the
> above shouldn't be exported:
> 
> ...
> /*
>  * __kfifo_in_... internal functions for put date into the fifo
>  * do not call it directly, use kfifo_in_rec() instead
>  */
> ...
> 
>   anyway, you get the idea.  it would seem that a lot of those EXPORTs
> should be removed, no?

If you look at kfifo_in_rec(), it's a static inline void function
defined in kfifo.h and which calls __kfifo_in_generic() or
__kfifo_in_rec(). I don't think you'll be able to make that work
without exporting those functions.

HTH
T.
