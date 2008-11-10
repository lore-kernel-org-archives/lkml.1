Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbYKJRPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbYKJRPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 12:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbYKJRPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 12:15:40 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:18756 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbYKJRPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 12:15:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=whSpO+cCofNiYKmQxvTv1Ezq/d/DTazBVzLNimjDPjgbY+KBuyXqFuUN8+cexzsPVx
         H//0ReTQvX623C92q/fkL9L3joGzAMVGhAzaUtmylwfMEqPIxnxYPSHNJcgd39WPkkTU
         vf2Y5w5SMghRGKAcpNRv61ZrKk3Ise5ExhX2o=
Message-ID: <cfd18e0f0811100915o8ea98a0s816921cee3163c1c@mail.gmail.com>
Date: Mon, 10 Nov 2008 12:15:36 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Evgeniy Polyakov" <zbr@ioremap.net>
Subject: Re: [1/1] Use pid in inotify events.
Cc: linux-kernel@vger.kernel.org, "Robert Love" <rlove@rlove.org>,
       linux-api@vger.kernel.org, "John McCutchan" <ttb@tentacle.dhs.org>
In-Reply-To: <20081110152043.GB15796@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081108114225.GA22674@ioremap.net>
	 <cfd18e0f0811080625w5b285cc0p2410e8d187b025c7@mail.gmail.com>
	 <20081108153545.GA3859@ioremap.net>
	 <cfd18e0f0811080858k7f6cddadg962771ed0cb3bdb8@mail.gmail.com>
	 <20081110152043.GB15796@ioremap.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Evgeniy,

On Mon, Nov 10, 2008 at 10:20 AM, Evgeniy Polyakov <zbr@ioremap.net> wrote:
> Hi Michael.
>
> On Sat, Nov 08, 2008 at 11:58:30AM -0500, Michael Kerrisk (mtk.manpages@googlemail.com) wrote:
>> It's perhaps unfortunate that the structure wasn't padded out with a
>> few additional fields "for future use".  But -- maybe it is not really
>> true that we can't change things.  Two things to consider:
>>
>> a) We now (since 2.6.27) have an inotify_init1() which has a flags argument.
>> b) There are spare bits in the mask argument of inotify_add_watch()
>>
>> We could use a flag in either of these to say that we want a different
>> structure returned on read() from the inotify descriptor.  In the
>> first case, this would be a global setting for all inotify events on
>> that descriptor.  In the second, we could do it on a per-watch basis
>> (I'm not so sure that that is a nice idea).  Since we are in any case
>> extending the ABI, and new applications would need to be taught about
>> the extension, it seems we could consider either of the alternative
>> extensions I mentioned, which woul also allow the PID to be obtained
>> for rename() events.  What do you think?
>
> This may be a good idea for some serious ABI change. I think we could
> extend it even more to include IO offset/size into events and attribute
> changes.

Are you going to revise your patch to use this idea?

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
