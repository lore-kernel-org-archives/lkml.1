Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbYKHQ6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbYKHQ6n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 11:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbYKHQ6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 11:58:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:35162 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbYKHQ6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 11:58:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=uN/zsUfGydZQ/W9ng8ftUvNT1TwGSwbJNj5+skexV3m6vpe4AYqsihx5Nu/2/czxmQ
         NAhGdkG2sbl8wXn9YMUmRmML5g58wV2oVxBk6ijIWLsURrRfFEvuuVxWzI2buzmq1yY3
         iqw1pYGh08tlCoKdsRcMLCv7TztIBvIlmtDR4=
Message-ID: <cfd18e0f0811080858k7f6cddadg962771ed0cb3bdb8@mail.gmail.com>
Date: Sat, 8 Nov 2008 11:58:30 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Evgeniy Polyakov" <zbr@ioremap.net>
Subject: Re: [1/1] Use pid in inotify events.
Cc: linux-kernel@vger.kernel.org, "Robert Love" <rlove@rlove.org>,
       linux-api@vger.kernel.org, "John McCutchan" <ttb@tentacle.dhs.org>
In-Reply-To: <20081108153545.GA3859@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081108114225.GA22674@ioremap.net>
	 <cfd18e0f0811080625w5b285cc0p2410e8d187b025c7@mail.gmail.com>
	 <20081108153545.GA3859@ioremap.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC += "John McCutchan" <ttb@tentacle.dhs.org>, who was one of the
inotify developers, as I recall]

Hi Evgeniy,

On Sat, Nov 8, 2008 at 10:35 AM, Evgeniy Polyakov <zbr@ioremap.net> wrote:
> Hi Michael.
>
> On Sat, Nov 08, 2008 at 09:25:16AM -0500, Michael Kerrisk (mtk.manpages@googlemail.com) wrote:
>> I've not looked closely at the patch, but a quick question.  The
>> ookied field is unused for _most_ events, but is used for rename
>> events.  Are you saying that with this patch, that the cookie will be
>> used as before for rename events, but for other events it will be the
>> PID of the triggering process?  If so, that seems a bit ugly -- why
>> wouldn't we also be intersted in the PID for rename events?
>
> Yes, rename events actually consist of at least two: move from and move
> to, and they carry the same cookie, so that userspace could combine them
> into single transaction. All others use zero, so I decided to put PID of
> the caller there. This does not look perfect of course, but we can not
> change the structure layout, so rename events can not be changed to
> carry additional PID field.

It's perhaps unfortunate that the structure wasn't padded out with a
few additional fields "for future use".  But -- maybe it is not really
true that we can't change things.  Two things to consider:

a) We now (since 2.6.27) have an inotify_init1() which has a flags argument.
b) There are spare bits in the mask argument of inotify_add_watch()

We could use a flag in either of these to say that we want a different
structure returned on read() from the inotify descriptor.  In the
first case, this would be a global setting for all inotify events on
that descriptor.  In the second, we could do it on a per-watch basis
(I'm not so sure that that is a nice idea).  Since we are in any case
extending the ABI, and new applications would need to be taught about
the extension, it seems we could consider either of the alternative
extensions I mentioned, which woul also allow the PID to be obtained
for rename() events.  What do you think?

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
