Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbYFWHjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbYFWHjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 03:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbYFWHit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 03:38:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750752AbYFWHit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 03:38:49 -0400
Date: Mon, 23 Jun 2008 00:37:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: free_beer_for_all@yahoo.com
Cc: linux-kernel@vger.kernel.org, Alex Woods <linux-dvb@giblets.org>,
       Peter Beutner <p.beutner@gmx.net>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Broken ttusb-dec DVB support since, well, year(s)
Message-Id: <20080623003747.f167b1af.akpm@linux-foundation.org>
In-Reply-To: <399205.76644.qm@web46108.mail.sp1.yahoo.com>
References: <399205.76644.qm@web46108.mail.sp1.yahoo.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jun 2008 23:55:29 -0700 (PDT) barry bouwsma <free_beer_for_all@yahoo.com> wrote:

> Moin moin!
> 
> Sorry I'm posting this here rather than to the more specific
> linux-dvb@ mailing list where I'd rather this appear, but my
> attempts to surbscibe!@! to that list have been rejected, first
> as an invalid e-mail, then an insecure e-mail, and I've been
> unable to progress further from this throwaway account.

These closed lists are a pain.

Lots of subprojects have moved their lists to vger.kernel.org in recent
months.  It gets close to zero spam.  Hint.

> Feel free to redirect/repost this message there if you're a
> qualified developer and feel it's more appropriate.
> 
> 
> There is a change that was introduced to the file
> drivers/media/dvb/ttusb-dec/ttusbdecfe.c
> sometime in the not-too-recent past and which resulted in breaking
> the support which early 2.6.1x kernels had for my Hauppauge
> DEC-3000s DVB-S device.
> 
> The particular code (below) checks the value in a register to
> decide the tuning status -- hitherto one had to assume the device
> was properly tuned and receiving signal and everything.
> 
> 
>      60         switch(result[3]) {
>      61                 case 1:  /* not tuned yet */
>      62                 case 2:  /* no signal/no lock*/
>      63                         break;
>      64                 case 3:  /* signal found and locked*/
>      65                         *status = FE_HAS_SIGNAL | FE_HAS_VITERBI |
>      66                         FE_HAS_SYNC | FE_HAS_CARRIER | FE_HAS_LOCK;
>      67                         break;
>      68                 case 4:
>      69                         *status = FE_TIMEDOUT;
>      70                         break;
>      71                 default:
>      72                         pr_info("%s: returned unknown value: %d\n",
>      73                                 __func__, result[3]);
>      74                         return -EIO;
>      75         }
> 
> 
> Unfortunately, while this might work for the other flavours of
> card (DVB-T?) supported by this code, in the case of my particular
> device for DVB-S, the unknown value returned is 0 and does not
> change regardless of tuning status.
> 
> I haven't checked whether a different register on my particular
> device contains a usable value for the above code.
> 
> In any case, with my particular device, in order to use more
> recent kernels, I've had to add a ``case 0:'' line to the
> ``case 3:'' seen above in order to get the previous behaviour
> where no check was made.
> 
> 
> As I don't know the particular model for which the quoted code
> was added, I don't know if my device is unique, or whether the
> number of DVB-S users of this code is miniscule, as nobody else
> has complained that I've seen.
> 
> Apologies for not reporting this long ago when first observed,
> but I've not had any meaningful Internet access in a long time
> to allow me more than just leeching the latest codes.
> 
> thanks,
> BOUWSMA Barry
> 

Thanks.  Cc's added.

