Return-Path: <linux-kernel-owner+w=401wt.eu-S935163AbYCFCgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935163AbYCFCgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 21:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934563AbYCFCau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 21:30:50 -0500
Received: from web36711.mail.mud.yahoo.com ([209.191.85.45]:35206 "HELO
	web36711.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934557AbYCFCas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 21:30:48 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=HmqRqZEOjBypTHZEctcYR6ofAAhVMnX6/rCna9m3bxUZsgz2X9BFY/AfnW6iGG96vgQX91XC7MM4OaPuypel5MxVd7Qb7h6/vmgX0VYVPEASileRZWGrlYDAIamKGchVvCKBkv48l0hOMnLwAF7E/DcOh/iq61TsilEiZdbjEsk=;
X-YMail-OSG: Y8SmQXcVM1kYW_Up5sIsgSeVPEJDItd0DBAGfVg5teEPsZrhaG7AJL5NgxtbL2A0IzGVU.BnPsnwqK98smBnZtsXoORV3LtCHKQPE9SwSbqrD6u6AVQ-
Date: Wed, 5 Mar 2008 18:30:46 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 05/11] tifm: fix the MemoryStick host fifo handling code
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <996921.54635.qm@web36711.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed,  5 Mar 2008 03:02:22 +1100
> oakad@exemail.com.au wrote:
> 
> > +			buf = kmap_atomic(pg, KM_BIO_SRC_IRQ) + p_off;
> 
> I am unable to convince myself that this driver always has local IRQs
> disabled when altering the KM_BIO_SRC_IRQ slot.  Does it?
> 

diff did rather bad job with this patch. The place in question looks like:


211: local_irq_save(flags);
212: buf = kmap_atomic(pg, KM_BIO_SRC_IRQ) + p_off;
....
....
223: kunmap_atomic(buf - p_off, KM_BIO_SRC_IRQ);
224: local_irq_restore(flags);



      ____________________________________________________________________________________
Never miss a thing.  Make Yahoo your home page. 
http://www.yahoo.com/r/hs
