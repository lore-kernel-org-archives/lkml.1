Return-Path: <linux-kernel-owner+w=401wt.eu-S1763493AbYBURcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763493AbYBURcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 12:32:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbYBURcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 12:32:01 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbYBURb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 12:31:59 -0500
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@pol.net, linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] fbdev: Make deferred I/O work as advertized
References: <871w76ejdg.fsf@pike.pond.sub.org>
	<87ve4id4rb.fsf@pike.pond.sub.org>
	<45a44e480802210830o1041e612sa532acde52e42748@mail.gmail.com>
From: Markus Armbruster <armbru@redhat.com>
Date: Thu, 21 Feb 2008 18:31:40 +0100
In-Reply-To: <45a44e480802210830o1041e612sa532acde52e42748@mail.gmail.com> (Jaya Kumar's message of "Fri\, 22 Feb 2008 00\:30\:58 +0800")
Message-ID: <878x1ecj2b.fsf@pike.pond.sub.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Jaya Kumar" <jayakumar.lkml@gmail.com> writes:

> On Thu, Feb 21, 2008 at 5:43 PM, Markus Armbruster <armbru@redhat.com> wrote:
>>  Fix extracted from this linux-fbdev-devel message:
>
> Hi Markus,
>
> Yes, this was discussed back in November on linux-mm and hence my
> patch. I didn't push for it to be merged by itself because I don't
> think it makes sense to merge it separately from the full metronomefb
> patch. As far as I can tell, only hecubafb and metronomefb seem to be
> the consumers.
>
> Out of curiosity, are you using defio or planning to use it? I would
> love to hear back from people who are using it.
>
> Thanks,
> jaya

Converting to fb_defio made xen-fbfront quite a bit simpler and much
more maintainable.  Excellent match.

It took me a bit of time to find your fix, mostly because I assumed my
own code was broken, not fb_defio.  It's best not to make assumptions
about who uses your code; if it's any good, chances are somebody will
find a use you never imagined.
