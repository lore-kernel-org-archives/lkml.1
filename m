Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbYCIKoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbYCIKoY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 06:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbYCIKoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 06:44:12 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:3992 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbYCIKoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 06:44:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=N9/8Ona58ipVe9qibdIG6Lw2I4jLal3GWStoTFa0QnwxtNobO/bWqYjeO517fmP1woHv5uc2+0mug+6sJL+bQBSf0xS76RzVWao1c0qIBDZ81lV68Gxc3zCcVKq09w0RjXsW6dNskTCXlbrXozseqiDthe82MlVcBl4yjYMoLOY=
Message-ID: <a8e1da0803090344l7f468326r8d3844e20ede08a3@mail.gmail.com>
Date: Sun, 9 Mar 2008 18:44:10 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v2] add time_now_after and other macros which compare with jiffies
Cc: "Johannes Weiner" <hannes@saeurebad.de>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080309095802.70d91c7b@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803080735.06984.hidave.darkstar@gmail.com>
	 <877igd6vqn.fsf@saeurebad.de>
	 <a8e1da0803081654l50fdda44jbbed1d1ed2caf9ae@mail.gmail.com>
	 <20080309095802.70d91c7b@core>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/9/08, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > >  > +/* time_now_before_eq(a) return true if now (jiffies) is before or equal to a */
>  > >  > +#define time_now_before_eq(a) time_before_eq(jiffies, a)
>  > >
>  > >  How about even more obvious names like time_is_past(), time_is_future(),
>  > >  ...?
>  >
>  > Thanks for comment.
>  >
>  > Then how do we name the _eq version?  IMHO, the time_now_* is enough.
>
>
> Why do you even need them. I don't see the point of *any* of these extra
>  macros as they simply obfuscate code and hide what is actually going on.
>  The initial macros were added because of the type safety and correct
>  comparison rules being complex. They have a purpose.

Yes, This has a purpose as well. You will find most of the usage of these
macros are just compare some value with jiffies after doing some grep.

For these cases this adding will easy use and understand.

>
>  Even if you want these you can use !time_future() if you don't want the
>  _eq variants. Generally speaking drivers should be using timers not
>  polled loops, and most of our loops comparing with jiffies want removing.
>

IMO time_after is a confusing name actually, If I don't read the comment I
will think it as time_future

To some extent I agree with you that the timer will be better.

>
>  Alan
>

Thanks
