Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbZCBGTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbZCBGTD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 01:19:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbZCBGSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 01:18:53 -0500
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:35582 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750786AbZCBGSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 01:18:52 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=MJJVPDvDCP+Hhr35J31seBuXpje3jGTqs7PES3DwozHFTrIzd/225WMY/75ps55JxVq8FDNv7nCoFzdoHDefgxtGf+dmKY7SzvjlfsEp62z76uI8qMugzl6XHjxDbSGRPfIPLXshXBNueuIN5XY42JWfe+BRdAO/F8Eb8d4H0U8=  ;
X-YMail-OSG: JcFAi5QVM1kD60GTwY.Q4s4mqOlxOYEgLL9B0RkNvr1_nItgFLE1TeWk4Mza9uIQlYPOWTi_S7h89rC6e61KhwyLCpQdOLrwrNf7xiFTQc7I34CQjVWXo8LgwHnnHtjle9dQ1ErdgcGUtjOHC16sHuayy6XY0Ok3vGzzqa5Hl0wpRe4.BnCHSVB7.6IJ_Q--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
Date: Mon, 2 Mar 2009 17:18:11 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Arjan van de Ven <arjan@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       mingo@elte.hu, sqazi@google.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
References: <alpine.LFD.2.00.0902280904271.3111@localhost.localdomain> <200903020106.51865.nickpiggin@yahoo.com.au> <49AB648B.5090302@zytor.com>
In-Reply-To: <49AB648B.5090302@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903021718.12402.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 March 2009 15:46:03 H. Peter Anvin wrote:
> Nick Piggin wrote:
> > I would expect any high performance CPU these days to combine entries
> > in the store queue, even for normal store instructions (especially for
> > linear memcpy patterns). Isn't this likely to be the case?
>
> Actually, that is often not the case simply because it doesn't buy that
> much.  The big win comes when you don't read a whole cache line in from
> memory, but that is a property of the cache, not the store queue.

Hm, maybe I'm confused. As far as I thought, you could avoid the
RMW write allocate behaviour by bypassing the cache on a store
miss, or combining stores into cacheline blocks before they leave
the store queue.

