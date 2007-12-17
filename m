Return-Path: <linux-kernel-owner+w=401wt.eu-S937023AbXLQX1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937023AbXLQX1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 18:27:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757037AbXLQX0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 18:26:53 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:48869 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673AbXLQX0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:26:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=fLgXMffj+0fjtabefQc4aft7S5Pmv+t2mG3ZZr/GXlVEI7LpOtCMtj/sBqUjVYH8oBLqm4/WNUJU8t60m42LRBK/Tq4c6NVr7OX+RKdoanQ/oGqy327ZSN0kwOuPVlEhDppaawtnZ/D/6leV/qMYxIrIx7INQyKdf9IkMIxsUtc=
Message-ID: <12c511ca0712171526h242a7de8vadec78cd48747bd@mail.gmail.com>
Date: Mon, 17 Dec 2007 15:26:46 -0800
From: "Tony Luck" <tony.luck@intel.com>
To: "Arjan van de Ven" <arjan@linux.intel.com>
Subject: Re: Top kernel oopses/warnings this week
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>, protasnb@gmail.com,
       tytso@thunk.org
In-Reply-To: <476703A4.7000401@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4762CF8C.90808@linux.intel.com> <20071217172331.GA23070@elte.hu>
	 <20071217133631.5bbc5842@laptopd505.fenrus.org>
	 <12c511ca0712171458n1bc05b40nab6b4b7c92433c8d@mail.gmail.com>
	 <476703A4.7000401@linux.intel.com>
X-Google-Sender-Auth: fa7b67243b1ab13e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 17, 2007 3:17 PM, Arjan van de Ven <arjan@linux.intel.com> wrote:
>
> Tony Luck wrote:
> >> +       static char target[80];
> >  ...
> >> +               sprintf(target, "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-"
> >> +                       "%02x%02x%02x%02x%02x%02x",
> >
> > [80] is overkill ... [37] bytes should be enough (unless I went
> > cross-eyed counting the "%02x" :-)
> >
>
> %02x doesn't guarantee that it's at most 2, but at LEAST 2...

How will you fit a number that requires >2 hex digits into an
"unsigned char"?

Alternatively ... if %02x may spew more that 2 characters, can
you be sure that [80] is enough?

-Tony
