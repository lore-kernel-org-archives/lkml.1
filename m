Return-Path: <linux-kernel-owner+w=401wt.eu-S1757778AbXLTVsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778AbXLTVsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 16:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbXLTVsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 16:48:32 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:32252 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbXLTVsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 16:48:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=iXRZjrSYU4E12izsLfwTnXJjme8UtoOeEjvobOvYRhsQnG9Sd4VqAekcBU1K9XGTksvrL1JA0WF6ObG8DYwGt55K8Cs5ufMJ16WPiMUhzjM/lhk634hq8NC2pCJcyL0Cv8i7gsFcpIz07Ba/tgrlUknBZ4oUBEWXVYKwo62O72A=
Message-ID: <84144f020712201348k117b7db5x6ab71de796bdee5b@mail.gmail.com>
Date: Thu, 20 Dec 2007 23:48:29 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "David Newall" <david@davidnewall.com>
Subject: Re: almost daily Kernel oops with 2.6.23.9 - and now 2.6.23.11 as well
Cc: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>,
       Scott <linux-kernel@bluecamel.eml.cc>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, hugh@veritas.com, stefanr@s5r6.in-berlin.de
In-Reply-To: <476A7E7E.7030704@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200712160106.00464.volker.armin.hemmann@tu-clausthal.de>
	 <200712200313.54425.volker.armin.hemmann@tu-clausthal.de>
	 <1198122641.8341.1.camel@oasis.donpoo.home>
	 <200712200653.28996.volker.armin.hemmann@tu-clausthal.de>
	 <476A7E7E.7030704@davidnewall.com>
X-Google-Sender-Auth: 6c4eff1a42cc0725
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Dec 20, 2007 4:38 PM, David Newall <david@davidnewall.com> wrote:
> >>> and another one, this time tainted with the nvidia module:
> >>> 5194.130985] Unable to handle kernel paging request at 0000030000000000
> >>> RIP:
>
> Numbers like that don't suggest hardware faults.  All those zeros: It's
> far too round.  Sounds very like software.  In fact, it sounds like the
> start of significant hardware region.

Nah, it's just that vma->anon_vma is probably supposed to be NULL here. And if
you look at all the oopses, they do suggest one particular byte lane
is dodgy (the
corruption is in bits 41-43 and 45).

The whole thing reminds me of another bug where memtest86 didn't find anything
because it's doing cached memory accesses: http://lkml.org/lkml/2007/10/3/259

                                Pekka
