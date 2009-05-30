Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbZE3HgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbZE3HgB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 03:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750939AbZE3Hfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 03:35:54 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:34490 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbZE3Hfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 03:35:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RwRAVXmH1vR5nWD4eGqt3i+xZ+36+/j/OoqL6/S4cx7ll8Q10fJXiPrsVjPo2FRSaY
         cJeN3+IPtq3pBncmGtl3o47HyxTpBcjnkgb5E1r+Ti9INDPdf1R8liW2Y5I5fpjzJsAk
         sZwSBrymI90NWCoLeO/DzMMcl8Vi8skQbtQvI=
MIME-Version: 1.0
In-Reply-To: <20090528125042.28c2676f@lxorguk.ukuu.org.uk>
References: <20090520183045.GB10547@oblivion.subreption.com>
	 <4A15A8C7.2030505@redhat.com> <20090522073436.GA3612@elte.hu>
	 <20090522113809.GB13971@oblivion.subreption.com>
	 <20090523124944.GA23042@elte.hu> <4A187BDE.5070601@redhat.com>
	 <20090527223421.GA9503@elte.hu>
	 <20090528072702.796622b6@lxorguk.ukuu.org.uk>
	 <20090528090836.GB6715@elte.hu>
	 <20090528125042.28c2676f@lxorguk.ukuu.org.uk>
Date: Sat, 30 May 2009 10:35:53 +0300
X-Google-Sender-Auth: dc38e18dec5377e2
Message-ID: <84144f020905300035g1d5461f9n9863d4dcdb6adac0@mail.gmail.com>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page 
	allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, Rik van Riel <riel@redhat.com>,
       "Larry H." <research@subreption.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Thu, May 28, 2009 at 2:50 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> The performance cost of such a security action are NIL when the feature
> is disabled. So the performance cost in the general case is irrelevant.
>
> If you need this kind of data wiping then the performance hit
> is basically irrelevant, the security comes first. You can NAK it all you
> like but it simply means that such users either have to apply patches or
> run something else.
>
> If it harmed general user performance you'd have a point - but its like
> SELinux you don't have to use it if you don't need the feature. Which it
> must be said is a lot better than much of the scheduler crud that has
> appeared over time which you can't make go away.

The GFP_SENSITIVE flag looks like a big hammer that we don't really
need IMHO. It seems to me that most of the actual call-sites (crypto
code, wireless keys, etc.) should probably just use kzfree()
unconditionally to make sure we don't leak sensitive data. I did not
look too closely but I don't think any of the sensitive kfree() calls
are in fastpaths so the performance impact is negligible.

                                Pekka
