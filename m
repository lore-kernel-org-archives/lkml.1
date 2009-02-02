Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbZBBP3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbZBBP3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 10:29:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbZBBP3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 10:29:38 -0500
Received: from senator.holtmann.net ([87.106.208.187]:42382 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbZBBP3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 10:29:37 -0500
Subject: Re: [PATCH V2] btsdio: fix tx error path
From: Marcel Holtmann <marcel@holtmann.org>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1ba2fa240902020615w239753a5v6973e77ed59128c9@mail.gmail.com>
References: <1223293223-21162-1-git-send-email-tomas.winkler@intel.com>
	 <1223294503.11272.158.camel@violet.holtmann.net>
	 <1ba2fa240902020615w239753a5v6973e77ed59128c9@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 16:29:51 +0100
Message-Id: <1233588591.4668.23.camel@californication>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomas,

> >> This patch fixes accumulating of the header
> >> in case packet was requeued in the error path.
> >>
> >> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> >> Cc: Marcel Holtmann <marcel@holtmann.org>
> >> ---
> >>  drivers/bluetooth/btsdio.c |    1 +
> >>  1 files changed, 1 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/bluetooth/btsdio.c b/drivers/bluetooth/btsdio.c
> >> index 58630cc..c422e89 100644
> >> --- a/drivers/bluetooth/btsdio.c
> >> +++ b/drivers/bluetooth/btsdio.c
> >> @@ -91,6 +91,7 @@ static int btsdio_tx_packet(struct btsdio_data *data, struct sk_buff *skb)
> >>
> >>       err = sdio_writesb(data->func, REG_TDAT, skb->data, skb->len);
> >>       if (err < 0) {
> >> +             skb_pull(skb, 4);
> >>               sdio_writeb(data->func, 0x01, REG_PC_WRT, NULL);
> >>               return err;
> >>       }
> >
> > thanks, but I already fixed that one manually in my tree :)
> >
> > Regards
> >
> > Marcel
> 
> Would you mind to queue it for 27 stable?  I'm always hitting this and
> I guess I'm not only one.
> http://marc.info/?l=linux-bluetooth&m=122513647106365&w=2

since besides development hardware, nobody really has this issue and I
think it doesn't really justify pushing this to -stable. However this is
up to the -stable guys and you can just sent it to stable@kernel.org by
yourself if you wanna have it included. Just point them to

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=7644d63d1348ec044ccd8f775fefe5eb7cbcac69

and explain you reason for adding it to -stable.

Regards

Marcel


