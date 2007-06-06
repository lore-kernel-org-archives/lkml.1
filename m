Return-Path: <linux-kernel-owner+w=401wt.eu-S1761859AbXFFG5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761859AbXFFG5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 02:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755026AbXFFG5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 02:57:05 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:20543 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314AbXFFG5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 02:57:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=lxLPu5R5AmWjDhf9fu0MCpoC20KGmXcpLZm6hRLIJT31sIxMxNGpPZBchh76N4DVfKhdbim3Ap1GuboO9TCjPPE2r5dRk7A6LjcQuaLA7Qoc4YChrXvygWBB2NEZRI7fWI4TEm5jwIKk1CvxwXhaF4n8dTantpbJu8v8mU/NZ/U=
Message-ID: <46665AB5.6040508@gmail.com>
Date: Wed, 06 Jun 2007 15:56:53 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Mikael Pettersson <mikpe@it.uu.se>, akpm@linux-foundation.org,
       david@dgreaves.com, jean.luc.coulon@gmail.com, jgarzik@pobox.com,
       michal.k.k.piotrowski@gmail.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.22-rc4 - sata_promise regression since -rc3
References: <200706052131.l55LVkYN000191@harpo.it.uu.se> <20070605215256.GT31565@havoc.gtf.org>
In-Reply-To: <20070605215256.GT31565@havoc.gtf.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Jeff Garzik wrote:
> On Tue, Jun 05, 2007 at 11:31:46PM +0200, Mikael Pettersson wrote:
>> I can easily reproduce the problem in 2.6.22-rc4. There are no
>> sata_promise changes between rc3 and rc4, but Tejun's libata
>> polling SETXFER change was included in rc4. Reverting it makes
>> sata_promise work again for me.
> 
> Ugh.

Ugh...

>> I suspect that sata_promise.c:pdc_interrupt() should detect
>> a qc w/ ATA_TFLAG_POLLING, treat the interrupt as spurious,
>> and just call ata_chk_status(qc), similar to how sata_inic162x.c,
>> sata_nv.c, sata_sil.c, and sata_vsc.c do things.
> 
> Yes, highly likely.

I'm not sure whether that will work.  I'll give a shot at it here.

> SFF-like controllers (and in this case, Promise is included in that
> list) with their own interrupt handlers need their own polling handling
> code.

One thing I don't understand is why IDENTIFY works.  IDENTIFY uses
polling too.  Hmm...

-- 
tejun
