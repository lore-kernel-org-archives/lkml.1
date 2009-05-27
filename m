Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569AbZE0Bir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbZE0Bir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 21:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbZE0Big
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 21:38:36 -0400
Received: from sh.osrg.net ([192.16.179.4]:49539 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbZE0Bif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 21:38:35 -0400
Date: Wed, 27 May 2009 10:36:40 +0900
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com,
       jens.axboe@oracle.com, rdreier@cisco.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       jack@suse.cz, yanmin_zhang@linux.intel.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 03/13] scsi: unify allocation of scsi command and sense
 buffer
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4A1C1331.8060304@panasas.com>
References: <1243349222.2815.22.camel@localhost.localdomain>
	<20090527003152X.fujita.tomonori@lab.ntt.co.jp>
	<4A1C1331.8060304@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090527103637W.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 27 May 2009 10:36:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009 19:05:05 +0300
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On 05/26/2009 06:31 PM, FUJITA Tomonori wrote:
> > 
> > Can we just fix some drivers not to do the DMA with the sense buffer in
> > scsi_cmnd? IIRC, there are only five or six drivers that do such.
> 
> This is not so.
> All drivers that go through scsi_eh_prep_cmnd() will eventually DMA through
> the regular read path. Including all the drivers that do nothing and let
> scsi-ml do the REQUEST_SENSE
> 
> Actually I have exact numbers, from the last time I did all that

Hmm, we discussed this before, I think.

scsi-ml uses scsi_eh_prep_cmnd only via scsi_send_eh_cmnd(). There are
some users of scsi_send_eh_cmnd in scsi-ml but only scsi_request_sense
does the DMA in the sense_buffer of scsi_cmnd.

Only scsi_error_handler() uses scsi_request_sense() and
scsi_send_eh_cmnd() works synchronously. So scsi-ml can easily avoid
the the DMA in the sense_buffer of scsi_cmnd if we have one sense
buffer per scsi_host.
