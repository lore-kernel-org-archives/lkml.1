Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbYIJQzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbYIJQzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 12:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbYIJQzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 12:55:25 -0400
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:36932 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752009AbYIJQzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 12:55:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=6uxxVdzwAQkeKs/KK4DN4cZlZkok9fenVpBNa5rEChM/ZJnDMJkbSsjqs1sB2ICyW2u1cUX2S+LWEyLqfIt3yn8EdVozc0LMG+KQwesjrvdqsHnSwe9hlmm4lBVLf2R/MCB/Pmc+H2IuEvyQpUCftUW0r0nTOK66FdkTWbJQSyw=  ;
X-YMail-OSG: JxiT4IwVM1mdE.SJNPqbyOMiUV859kXmn6V6CV0HY0hT96fqlO_ZFh_6BOD8O1A6ZVeIqteYnuVdRpO5sOAeOSJ3.p06JIxrPLt4rdo7Lpw0m2_WUsbpXPHyCi4UdsfgczY-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [Xen-devel] Re: [PATCH 1 of 7] x86: add _PAGE_IOMAP pte flag for =?iso-8859-1?q?IO=09mappings?=
Date: Thu, 11 Sep 2008 02:55:03 +1000
User-Agent: KMail/1.9.5
Cc: Avi Kivity <avi@qumranet.com>, Ingo Molnar <mingo@elte.hu>,
       Xen Devel <xen-devel@lists.xensource.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
References: <4d93ba619c716c45cca0.1220826073@localhost> <48C7998D.1030408@qumranet.com> <48C7F80C.6000807@goop.org>
In-Reply-To: <48C7F80C.6000807@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809110255.03580.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 September 2008 02:38, Jeremy Fitzhardinge wrote:
> Avi Kivity wrote:
> > Actually it's more of a "no struct page" flag, which implies no
> > refcounting.
>
> Hm, is that actually true enough to define it?  Could we rename it
> something like _PAGE_NOSTRUCTPAGE or something a bit more specific than
> "special"?

It complements vm_normal_page, which was there first (and coined by
Linus). It is the opposite of normal. This question always comes up
and my answer is always yes, if you can convince Linus to rename
vm_normal_page to the corresponding term :)

It's not exactly _PAGE_NOSTRUCTPAGE. There can be struct pages under
there, but you're not to touch them.


> >   And not having a struct page should correspond well to a pte not
> > requiring pfn->mfn conversion and being an I/O page.
>
> But _PAGE_SPECIAL is only set in a few places.  It's not set in ioremap
> mappings and so on.  Should it be?

Kernel address space, you mean? No, it is only ever used on user
addresses.


> There's also the hiccup that it gets set in a pte with pte_mkspecial() -
> but at that point its too late because you've already constructed the
> pte and done the pfn->mfn conversion.  _PAGE_IOMAP can only be set when
> you initially construct the pte out of a frame number and a pgprot.

I don't see this would be any problem because the pte is always constructed
in a single line in both places where it is used.
