Return-Path: <linux-kernel-owner+w=401wt.eu-S1764509AbXE2LLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764509AbXE2LLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 07:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbXE2LLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 07:11:43 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:36750 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753579AbXE2LLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 07:11:42 -0400
Date: Tue, 29 May 2007 13:11:41 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Christoph Hellwig <hch@lst.de>
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [patch 6/7] ps3: ROM Storage Driver
In-Reply-To: <20070529104948.GC29351@lst.de>
Message-ID: <Pine.LNX.4.62.0705291308280.7698@pademelon.sonytel.be>
References: <20070525083607.784351000@sonycom.com> <20070525083632.677742000@sonycom.com>
 <20070529104948.GC29351@lst.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007, Christoph Hellwig wrote:
> [Note that all scsi lldds should go to linux-scsi]

I'll Cc linux-scsi next time.

> > +	sgpnt = cmd->request_buffer;
> > +	active = 1;
> > +	for (k = 0, req_len = 0, act_len = 0; k < cmd->use_sg; ++k, ++sgpnt) {
> > +		if (active) {
> > +			kaddr = kmap_atomic(sgpnt->page, KM_USER0);
> > +			if (!kaddr)
> > +				return DID_ERROR << 16;
> > +			len = sgpnt->length;
> > +			if ((req_len + len) > buflen) {
> > +				active = 0;
> > +				len = buflen - req_len;
> > +			}
> > +			memcpy(kaddr + sgpnt->offset, buf + req_len, len);
> > +			kunmap_atomic(kaddr, KM_USER0);
> > +			act_len += len;
> > +		}
> > +		req_len += sgpnt->length;
> > +	}
> > +	cmd->resid = req_len - act_len;
> 
> This looks very inefficient.  Just set sg_tablesize of your driver
> to 1 to avoid getting mutiple segments.

The disadvantage of setting sg_tablesize = 1 is that the driver will get small
requests (PAGE_SIZE) most of the time, which is very bad for performance.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
