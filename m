Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbYKQRXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbYKQRXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 12:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbYKQRXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 12:23:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:11052 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbYKQRXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 12:23:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=jZnWFu6hzqaH1676Ez5c6B28Zah0Pb3DEaa1SKjvGUv21EFG3C0nILg5tyESD1A4vc
         ZECVj8qfRJx6t5xSuraIze40Whu8hrVeVYXgNMkc5TPWXQnpuoBAywB0HnYgMUJmOWn6
         yI+uBjQIAuP7ouoSuAa6CpF4uTH2M/ckLeLMk=
Message-ID: <cfd18e0f0811170923q6b72bd0fn9d319bbceb8fa6a@mail.gmail.com>
Date: Mon, 17 Nov 2008 12:23:01 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Evgeniy Polyakov" <zbr@ioremap.net>
Subject: Re: [take 3] Use pid in inotify events.
Cc: "Robert Love" <rlove@rlove.org>, linux-api@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Hellwig" <hch@lst.de>
In-Reply-To: <20081117171508.GA564@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com>
	 <20081116232450.GA13547@ioremap.net>
	 <cfd18e0f0811170859w1d3f903ej1d5626f2d2bf4496@mail.gmail.com>
	 <20081117171508.GA564@ioremap.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Evgeniy,

On Mon, Nov 17, 2008 at 12:15 PM, Evgeniy Polyakov <zbr@ioremap.net> wrote:
> Hi Michael.
>
> On Mon, Nov 17, 2008 at 11:59:11AM -0500, Michael Kerrisk (mtk.manpages@googlemail.com) wrote:
>> NAK.  If we are going to do this -- and I leave the security
>> discussions to others more knowlegeable on that score than me -- then
>> the API design should be better than this.  The current design is a
>> hack.  Why exclude rename events?  Why re-use the cookie field?  The
>> only answers I can guess at are that the current patch is less work to
>> write.  IMO, there are (much) better design possibilities, using
>> inotify1(), as I suggested earlier in this thread.
>
> Cookie was created to store information used to somehow connect events to
> each other. PID does that from another angle than rename.

Yes, but it does it in an inconsistent, incomplete way.

> Extending
> (rewriting userspace event processing part) events is a solution for the
> new project,

Not quite sure of your point here.  Whatever change is made, userspace
apps will need to be trained to understand the interface.

> while existing patch (where all security concerns are
> resolved) is a minimum functionality extension.

It is a minimum functionality extension that serves the needs of one
or a few projects, while dirtying the design for all users.

> if I will spent a day and rewrite userspace report side to report new
> events I'm pretty sure there will be people, who will start complaining
> that again design does not match some theoretically perfect
> expectations,

Maybe.  Mabe not.  But that is (a necessary) part of the design process.

> and for the purpose of reporting origin's PID cookie
> fields can be reused since right now it is unused.

You didn't really respond to my earlier comment.  Why are you doing
things this way.  As far as I can see, only becuase it is quicker to
implement.

> Plus, if it is that hard to comment on patch which adds 14 (!) lines
> including blank, which feedback we should expect on larger one? :)

Still NAK, sorry.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
