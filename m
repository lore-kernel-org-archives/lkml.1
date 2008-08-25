Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013AbYHYIA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbYHYIA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 04:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbYHYIAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 04:00:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:30987 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbYHYIAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 04:00:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jw71KleVTgWp98xHeSR3/xvTRKKy+Ciy8Lx0WrzhL+Byqbez1fk+F2Zt7hSceK4wo4
         2TLFbgKFKJDBVSJPVDmZiMgaGP60CTKZDzDH/3iaJ3PV9rCooi7v+w3QZopMHHQva8rf
         VT3UNu/lKvvgTwkdiNiaPqw/HmdyxQ0G1iM+o=
Message-ID: <86802c440808250100g15b056e0l359e83c6a8ee488b@mail.gmail.com>
Date: Mon, 25 Aug 2008 01:00:50 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
Cc: "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20080825073125.GA27950@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <914225.91320.qm@web82104.mail.mud.yahoo.com>
	 <86802c440808242141j716b5875s709dc56c1163a7d5@mail.gmail.com>
	 <20080825073125.GA27950@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 12:31 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> this one should work. please apply this one only.
>>
>> YH
>>
>> [PATCH] x86: check hpet with BAR v2
>
> great. I've cleaned it up a bit (see the final commit below) and queued
> it up in tip/x86/urgent for some testing. But there are a few open
> questions, and an Ack/feedback from Jesse/Linus would be nice as well:
>
> - the forced insertion and the embedded knowledge about iomem_resource
>  and ioport_resource looks ugly to me.
>
> - we should also extend this to other platform resource types that we
>  know about: ioapic address(es) might be a prime candidate. (local
>  APICs are CPU entities and should never show up as PCI devices) The
>  mmconfig range is already properly accounted for by the PCI code
>  itself, right?

please check v3

>
> - plus a more highlevel approach would be nice as well i think - making
>  sure that the hpet driver runs before any of the PCI code, and
>  inserting a special "sticky" resource there which would keep any
>  potential followup generic PCI resource that overlaps this resource
>  untouched. (with a proper kernel warning emitted as well - such
>  situations are likely BIOS bugs.)

yes, can remove that late_initcall tricky code to insert resource for
lapic and ioapic, and mmconfig etc.

YH
