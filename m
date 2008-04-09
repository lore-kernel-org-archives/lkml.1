Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824AbYDISiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbYDISiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 14:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbYDISic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 14:38:32 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:62222 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbYDISi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 14:38:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=vURMUc1fMdN1ldbHlcqvj197QW+GQQA6lOIaSbRk7RdXAwN/FIMrX7Q2nvZHRB4EXLjLqLfYnW9LC1iJEAD1QHv4EQUUZawhfo9ft4DnhLo86dsLr0pnl/7s1uWVWidLUjijnrmxdcpOGQHX/827Nv40qImHkxkgqq1Y11uxmjE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Richard Zidlicky <rz@linux-m68k.org>
Subject: Re: [PATCH 5/5] falconide/q40ide: add ->atapi_*put_bytes and ->ata_*put_data methods
Date: Wed, 9 Apr 2008 20:49:25 +0200
User-Agent: KMail/1.9.9
Cc: Michael Schmitz <schmitz@zirkon.biophys.uni-duesseldorf.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-ide@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Michael Schmitz <schmitz@debian.org>
References: <200803301714.04527.bzolnier@gmail.com> <alpine.DEB.1.00.0804090337110.19638@zirkon.biophys.uni-duesseldorf.de> <20080409181314.GA999@linux-m68k.org>
In-Reply-To: <20080409181314.GA999@linux-m68k.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804092049.25594.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday 09 April 2008, Richard Zidlicky wrote:
> On Wed, Apr 09, 2008 at 03:40:34AM +0200, Michael Schmitz wrote:
> 
> > > However, not only FS data is byteswapped, complete disk including partition
> > > table and everything else is. Will "rq->cmd_type == REQ_TYPE_FS" also catch
> > > all these cases?
> > 
> >  IIRC only identify data (and perhaps ATAPI data) need to be byteswapped 
> >  twice (or not at all), so REQ_TYPE_FS should catch all other cases.
> 
> my main worry is whether REQ_TYPE_FS is set even when using raw disk access,
> eg reading partition table or raw partitions.

AFAIK direct I/O is also handled by REQ_TYPE_FS requests so it should be fine.

Only special commands (identify, S.M.A.R.T., raw commands passed through
taskfile ioctl) should be byte-swapped.

I just merged the patch into IDE tree (together with few other changes)
so some testing would be greatly appreciated.

Thanks,
Bart
