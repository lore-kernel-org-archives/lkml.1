Return-Path: <linux-kernel-owner+w=401wt.eu-S1753294AbYIJQi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbYIJQi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 12:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbYIJQis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 12:38:48 -0400
Received: from gw.goop.org ([64.81.55.164]:32824 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbYIJQis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 12:38:48 -0400
Message-ID: <48C7F80C.6000807@goop.org>
Date: Wed, 10 Sep 2008 09:38:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: Ingo Molnar <mingo@elte.hu>, Xen Devel <xen-devel@lists.xensource.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] Re: [PATCH 1 of 7] x86: add _PAGE_IOMAP pte flag
 for IO	mappings
References: <4d93ba619c716c45cca0.1220826073@localhost>	<48C67AE0.5060503@qumranet.com> <48C68C6B.7030803@goop.org> <48C68EA3.4050508@qumranet.com> <48C7998D.1030408@qumranet.com>
In-Reply-To: <48C7998D.1030408@qumranet.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Actually it's more of a "no struct page" flag, which implies no
> refcounting.

Hm, is that actually true enough to define it?  Could we rename it
something like _PAGE_NOSTRUCTPAGE or something a bit more specific than
"special"?

>   And not having a struct page should correspond well to a pte not
> requiring pfn->mfn conversion and being an I/O page.

But _PAGE_SPECIAL is only set in a few places.  It's not set in ioremap
mappings and so on.  Should it be?

There's also the hiccup that it gets set in a pte with pte_mkspecial() -
but at that point its too late because you've already constructed the
pte and done the pfn->mfn conversion.  _PAGE_IOMAP can only be set when
you initially construct the pte out of a frame number and a pgprot.

    J
