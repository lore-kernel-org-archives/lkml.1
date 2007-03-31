Return-Path: <linux-kernel-owner+w=401wt.eu-S1752607AbXCaJ1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbXCaJ1E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 05:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbXCaJ1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 05:27:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51130 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbXCaJ1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 05:27:01 -0400
Date: Sat, 31 Mar 2007 10:26:44 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Ed Lin <ed.lin@promise.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "james.Bottomley" <james.Bottomley@SteelEye.com>,
       jeff <jeff@garzik.org>, promise_linux <promise_linux@promise.com>
Subject: Re: [PATCH 1/4] [SCSI]stex: fix id mapping issue
Message-ID: <20070331092644.GA25989@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Ed Lin <ed.lin@promise.com>,
	linux-scsi <linux-scsi@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"james.Bottomley" <james.Bottomley@SteelEye.com>,
	jeff <jeff@garzik.org>, promise_linux <promise_linux@promise.com>
References: <NONAMEBZNuIkdg0MZMt000005d3@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <NONAMEBZNuIkdg0MZMt000005d3@nonameb.ptu.promise.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 03:21:33PM -0700, Ed Lin wrote:
> +	if (hba->cardtype == st_shasta) {
>  		req->lun = lun;
>  		req->target = id;
> +	} else if (hba->cardtype == st_yosemite){
> +		req->lun = id * ST_MAX_LUN_PER_TARGET + lun;
> +		req->target = 0;
> +	} else {
> +		/* st_vsc and st_vsc1 */
> +		req->lun = 0;
> +		req->target = id * ST_MAX_LUN_PER_TARGET + lun;

I don't get why you can't export id as targer and lun as lun for
the !st_shasta types.  Could you explain in detail what the problem
with that approach would be?

