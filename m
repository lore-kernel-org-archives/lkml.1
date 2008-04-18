Return-Path: <linux-kernel-owner+w=401wt.eu-S1761204AbYDRTjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761204AbYDRTjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 15:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760914AbYDRTix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 15:38:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:50470 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760890AbYDRTiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 15:38:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=uaHwJVjoVvOF/WX+DVtmOSXkS0x111iCa8TY0jqrdprwh+opQGIY5smkXP00GmdPqWh/4QHMZ/SCWV1iP9uNo0AfpZcvH+2tmVm2XOgXfvTl9TafKc2Ok/QBKfWmkkuutCVBEH15B3RcCyZ0NGGBsivaRmgWbUmH5EURrjwkEts=
Message-ID: <517f3f820804181238s79326d10tf898691f997715e5@mail.gmail.com>
Date: Fri, 18 Apr 2008 21:38:50 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] /dev/vring: simple userspace-kernel ringbuffer interface.
Cc: "Rusty Russell" <rusty@rustcorp.com.au>, netdev@vger.kernel.org,
       "Max Krasnyansky" <maxk@qualcomm.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Michael Kerrisk" <mtk.manpages@gmail.com>
In-Reply-To: <20080418115959.6b8fdfa7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804181433.48488.rusty@rustcorp.com.au>
	 <200804181439.49051.rusty@rustcorp.com.au>
	 <20080418041846.db15150b.akpm@linux-foundation.org>
	 <200804190032.39626.rusty@rustcorp.com.au>
	 <20080418115959.6b8fdfa7.akpm@linux-foundation.org>
X-Google-Sender-Auth: b8b2685cd3512730
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/18/08, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sat, 19 Apr 2008 00:32:39 +1000 Rusty Russell <rusty@rustcorp.com.au> wrote:
>
>  > > Isn't this kinda-sorta like what a relayfs file does?  The oprofile
>  > > buffers?  etc?  Nothing in common at all, no hope?
>  >
>  > An excellent question, but I thought the modern kernel etiquette was to only
>  > comment on whitespace and formatting, and call it "review"? :)
>  >
>  > Yes, kinda-sorta in that it's a ring buffer.  No, in that it's bidir and
>  > consumption can be out-of-order (kind of important for I/O buffers).
>  >
>  > But the reason I'm not proposing it as a syscall is that I'm not convinced
>  > it's the One True Solution which everyone should be using.  Time will tell:
>  > it's clearly not tied to tun and it's been generically useful for virtual
>  > I/O, but history has not been kind to new userspace interfaces.
>
>
> This is may be our third high-bandwidth user/kernel interface to transport
>  bulk data ("hbukittbd") which was implemented because its predecessors
>  weren't quite right.  In a year or two's time someone else will need a
>  hbukittbd and will find that the existing three aren't quite right and will
>  give us another one.  One day we need to stop doing this ;)
>
>  It could be that this person will look at Rusty's hbukittbd and find that
>  it _could_ be tweaked to do what he wants, but it's already shipping and
>  it's part of the kernel API and hence can't be made to do what he wants.
>
>  So I think it would be good to plonk the proposed interface on the table
>  and have a poke at it.  Is it compat-safe?  Is it extensible in a
>  backward-compatible fashion?  Are there future-safe changes we should make
>  to it?  Can Michael Kerrisk understand, review and document it?  etc.

Well, it helps if he's CCed....

I'm happy to work *with someone* on the documentation (pointless to do
it on my own -- how do I know what Rusty's *intended* behavior for the
interface is), and review, and testing.
