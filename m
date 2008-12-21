Return-Path: <linux-kernel-owner+w=401wt.eu-S1751516AbYLUTMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbYLUTMU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 14:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750782AbYLUTML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 14:12:11 -0500
Received: from mail.gmx.net ([213.165.64.20]:53317 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750744AbYLUTMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 14:12:10 -0500
X-Authenticated: #527675
X-Provags-ID: V01U2FsdGVkX19vrXwk0qlvdaP9cyKPatVdLWndbafLk6UqP8KM3L
	pUFqWJLDwEDbUa
Message-ID: <494E94FF.3090809@gmx.de>
Date: Sun, 21 Dec 2008 20:11:59 +0100
From: Reinhard Nissl <rnissl@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.8.1.17) Gecko/20080922 SUSE/2.0.0.17-0.1 Thunderbird/2.0.0.17 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Greg KH <greg@kroah.com>, akpm@linux-foundation.org, stable@kernel.org
Subject: Re: PATCH: mvsas: increase port type detection delay to suit	Seagate's
 15k6 drive ST3450856SS 0003
References: <49458D9C.5080906@gmx.de> <20081215000412.GC5622@kroah.com>
In-Reply-To: <20081215000412.GC5622@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------070906090405010202080502"
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070906090405010202080502
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

Greg KH schrieb:

> On Sun, Dec 14, 2008 at 11:50:04PM +0100, Reinhard Nissl wrote:
>
>> Hi Greg,
>>
>> I hope you don't mind following your suggestion:
>>
>>> Also, please cc: the stable developers if you want them to pay attention
>>> to messages like this.
> 
> It's easier to email stable@kernel.org to make sure that I don't miss it
> :)
> 
> Is the patch below in Linus's tree?  If so, do you have a git commit id?

This time, the attached patch is against Linus' tree
(linux/kernel/git/torvalds/linux-2.6.git). I'd be glad if Andrew
would commit it so that you can pull it over to stable.

Thanks in advance.

Bye.
-- 
Dipl.-Inform. (FH) Reinhard Nissl
mailto:rnissl@gmx.de

> If not, we need to wait until it is there before we can accept it into
> the stable tree.
> 
> thanks,
> 
> greg k-h
> 
>> -------- Original-Nachricht --------
>> Betreff: Re: PATCH: mvsas: increase port type detection delay to
>> suit Seagate's 15k6 drive ST3450856SS 0003
>> Datum: Fri, 12 Dec 2008 21:23:45 +0100
>> Von: Reinhard Nissl <rnissl@gmx.de>
>> An: linux-scsi@vger.kernel.org
>> CC: Ke Wei <kewei@marvell.com>, Jeff Garzik
>> <jgarzik@redhat.com>,	James Bottomley
>> <James.Bottomley@hansenpartnership.com>
>> Referenzen: <493BC76F.3060105@gmx.de> <49405137.9000902@gmx.de>
>>
>> Hi,
>>
>> I wonder why no one has dropped me a line so far. I hope you
>> don't mind CCing you directly. I found your email addresses on
>> mailing list entries regarding mvsas. I attach the little patch
>> again for ease of use.
>>
>> Reinhard Nissl schrieb:
>>
>>> I increased the delay step by step until loading of mvsas
>>> reliably detected the drive 200 times in sequence. A much better
>>> approach would be to monitor the hardware for some flag which
>>> indicates that port detection has finished, but I do not have any
>>> hardware documentation.
>>>
>>> BTW: patch is against
>>> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
>>>
>>> Signed-off-by: Reinhard Nissl <rnissl@gmx.de>

--------------070906090405010202080502
Content-Type: text/x-patch;
 name="mvsas.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mvsas.diff"

 drivers/scsi/mvsas.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
index 1dd70d7..23e5a87 100644
--- a/drivers/scsi/mvsas.c
+++ b/drivers/scsi/mvsas.c
@@ -2959,7 +2959,7 @@ static int __devinit mvs_hw_init(struct mvs_info *mvi)
 
 	/* enable auto port detection */
 	mw32(GBL_PORT_TYPE, MODE_AUTO_DET_EN);
-	msleep(100);
+	msleep(1100);
 	/* init and reset phys */
 	for (i = 0; i < mvi->chip->n_phy; i++) {
 		u32 lo = be32_to_cpu(*(u32 *)&mvi->sas_addr[4]);

--------------070906090405010202080502--
