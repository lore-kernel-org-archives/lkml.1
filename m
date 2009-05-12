Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbZELPX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbZELPX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbZELPXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:23:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:60869 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229AbZELPXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:23:02 -0400
Message-ID: <4A0993BA.7090505@kernel.org>
Date: Wed, 13 May 2009 00:20:26 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com,
       sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com,
       stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp,
       zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com,
       sfr@canb.auug.org.au, grant.likely@secretlab.ca,
       paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com,
       adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org,
       schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net,
       rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com,
       Doug Gilbert <dgilbert@interlog.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 03/11] block: add rq->resid_len
References: <1241423927-11871-1-git-send-email-tj@kernel.org> <1241423927-11871-4-git-send-email-tj@kernel.org> <4A06DFAB.40205@panasas.com> <4A0767E5.5050205@kernel.org> <4A080C9D.9000109@panasas.com> <4A08C26E.80801@kernel.org> <4A093782.80701@panasas.com> <4A093C54.2060706@kernel.org> <4A0946D6.4010405@panasas.com> <4A094A11.2030300@kernel.org> <4A09589A.5030800@panasas.com>
In-Reply-To: <4A09589A.5030800@panasas.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 12 May 2009 15:20:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:

> The solution to this, I think, is that the bouncing layer should
> receive a residual count, and not bounce anything beyond what's
> transferred. (On reads, writes does nothing), and zero-out the
> rest. This of course means that all block drivers make sure residual
> is properly set, the way it should as explained in this
> thread. (SCSI does the right thing where it can, for example see
> scsi_execute())

Umm... shouldn't the request just be successfully finished with
positive residue count and with sense data if necessary?  Block layer
request failure means, and has always meant, complete failure.

Thanks.

-- 
tejun
