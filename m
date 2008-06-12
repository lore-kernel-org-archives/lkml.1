Return-Path: <linux-kernel-owner+w=401wt.eu-S1762088AbYFLNnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762088AbYFLNnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761525AbYFLNnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:43:39 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:8827 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761015AbYFLNng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:43:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=C5l7AIt2EOrFLUwQgIcdvwvs6KRDhjqmOhtlUeXl1OGBspogLGI2uJlTxobeUlcpjW
         yWoYmHeuREIj9XZ274ZnKRlt02v3nH9+sW1o3bnpnRWe//x6F/U2WGfwF6pHCLjdWsIH
         G9loUP3ddZ4w4aRUR7So8yCjHYVn4bcaalOEo=
Message-ID: <48512801.7090502@gmail.com>
Date: Thu, 12 Jun 2008 22:43:29 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Elias Oltmanns <eo@nebensachen.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Prevent busy looping
References: <20080416151305.8788.63912.stgit@denkblock.local>	<20080416163152.GK12774@kernel.dk> <87r6d5l9pb.fsf@denkblock.local>	<20080417071335.GR12774@kernel.dk> <87ve2gc1bn.fsf@denkblock.local>	<484F7A8D.1040809@gmail.com> <20080611080502.4aa43980@core>	<484F86D4.8050907@gmail.com> <485092C9.3050309@gmail.com> <87d4mmubvf.fsf@denkblock.local>
In-Reply-To: <87d4mmubvf.fsf@denkblock.local>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns wrote:
> Since I'm a little confused by your comment, please explain again. Do
> you mean to say that busy looping doesn't lock up the machine in general
> or merely in the case of a simplex configuration?

It busy loops but it won't lock up as command completion is the loop
breaker and command completion comes via IRQ and the busy looping
doesn't happen solely in the IRQ context.  Still needs to be fixed tho.
 Anyways, this is only limited to ->qc_defer for simplex and the reason
why there's busy loop is because we're trying to schedule two
independent hosts and SCSI midlayer (of course) doesn't have the notion
of cross host deferring.

Thanks.

-- 
tejun
