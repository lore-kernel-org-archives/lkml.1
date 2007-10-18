Return-Path: <linux-kernel-owner+w=401wt.eu-S1762970AbXJRJO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762970AbXJRJO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 05:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758127AbXJRJOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 05:14:48 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51035 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756223AbXJRJOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 05:14:47 -0400
Message-ID: <471723F0.7050002@garzik.org>
Date: Thu, 18 Oct 2007 05:14:24 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Benny Halevy <bhalevy@panasas.com>
CC: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
References: <20071017172932.GI15552@kernel.dk>	 <20071017175337.GN15552@kernel.dk> <20071017183716.GU15552@kernel.dk>	 <20071017190901.GA13780@elte.hu>	 <alpine.LFD.0.999.0710171217160.26902@woody.linux-foundation.org>	 <20071017193542.GA15552@kernel.dk> <20071018070706.GA7435@elte.hu>	 <471717BF.4030108@pobox.com> <20071018083213.GN5063@kernel.dk>	 <471720FE.4090004@garzik.org> <bd58e4af0710180210tcc0d31ep9d05a0f2e9d6df29@mail.gmail.com>
In-Reply-To: <bd58e4af0710180210tcc0d31ep9d05a0f2e9d6df29@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benny Halevy wrote:
> 
> 
> On 10/18/07, *Jeff Garzik* <jeff@garzik.org <mailto:jeff@garzik.org>> wrote:
> 
>     Jens Axboe wrote:
>      > index 4df8311..b858183 100644
>      > --- a/drivers/ata/sata_mv.c
>      > +++ b/drivers/ata/sata_mv.c
>      > @@ -1139,6 +1139,7 @@ static void mv_fill_sg(struct
>     ata_queued_cmd *qc)
>      >       struct mv_port_priv *pp = qc->ap->private_data;
>      >       struct scatterlist *sg;
>      >       struct mv_sg *mv_sg;
>      > +     int end_marked = 0;
>      >
>      >       mv_sg = pp->sg_tbl;
>      >       ata_for_each_sg(sg, qc) {
>      > @@ -1159,13 +1160,15 @@ static void mv_fill_sg(struct
>     ata_queued_cmd *qc)
>      >                       sg_len -= len;
>      >                       addr += len;
>      >
>      > -                     if (!sg_len && ata_sg_is_last(sg, qc))
>      > +                     if (!sg_len && ata_sg_is_last(sg, qc)) { 
> 
> 
> I'm not sure, but shouldn't that be || rather than &&?

sg_len is zero at the end of each scatterlist entry, so we need to test 
the additional ata_sg_is_last() condition to determine if we are really 
at the end of the PRD table.

	Jeff



