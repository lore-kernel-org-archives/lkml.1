Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265AbZEZQF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbZEZQF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 12:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755071AbZEZQFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 12:05:13 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:51777 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbZEZQFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 12:05:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nIBiNC7uwTG6SEWRM6WsNNnN6RbMzJXdGAfv3G3cDmyH7fDyw5QmrpkMjtaAD8DWqr
         S4UmIJ8o+ZxQvPFskDI9Ee7dDUUt7acaArvM/2UBiWSQEc7I+GsKRakTNYau/wmieJrp
         oRiBbyDa2bIyWYo8wSCaa0fSjxrkMdAHEkRmw=
Message-ID: <4A1C1331.8060304@panasas.com>
Date: Tue, 26 May 2009 19:05:05 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com,
       rdreier@cisco.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       jack@suse.cz, yanmin_zhang@linux.intel.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 03/13] scsi: unify allocation of scsi command and sense
 buffer
References: <20090526073229.GC11363@kernel.dk>	<20090526163823U.fujita.tomonori@lab.ntt.co.jp>	<1243349222.2815.22.camel@localhost.localdomain> <20090527003152X.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090527003152X.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2009 06:31 PM, FUJITA Tomonori wrote:
> 
> Can we just fix some drivers not to do the DMA with the sense buffer in
> scsi_cmnd? IIRC, there are only five or six drivers that do such.

This is not so.
All drivers that go through scsi_eh_prep_cmnd() will eventually DMA through
the regular read path. Including all the drivers that do nothing and let
scsi-ml do the REQUEST_SENSE

Actually I have exact numbers, from the last time I did all that

Boaz
