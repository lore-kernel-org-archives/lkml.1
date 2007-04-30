Return-Path: <linux-kernel-owner+w=401wt.eu-S1423656AbXD3VRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423656AbXD3VRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 17:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423669AbXD3VRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 17:17:20 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:57452 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423656AbXD3VRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 17:17:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=N2NeypZVzsGpjqrfy9NzUfV6wqFzSszkPZSWDmCW5UTpXKBIu49CNRFT/2VO6I24tSMLZrYOE13yItLBR3ya517cL3ES7xZHIXGlSZcY+fKjF5TTN1g8VTXT6aOczRm2dvwt020+5AnJauzy4GS3Q4mfsI2leKLp4+aQFoytH9Y=
Message-ID: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com>
Date: Mon, 30 Apr 2007 23:17:16 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Subject: DST/BT878 module customization (.. was: Critical points about ...)
Cc: "Uwe Bugla" <uwe.bugla@gmx.de>,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       helge.hafting@aitel.hist.no, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-dvb@linuxtv.org, "Manu Abraham" <abraham.manu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Trent Piepho wrote another patch for it, it just completes Uwe's patch
in the end.

http://linuxtv.org/hg/~tap/dst-new?cmd=changeset;node=bbdd2b53cd5c;style=gitweb

as far as I see from that patch it cleans up a memory leak which would
happen when the system tries to load the dst module if it's not
available and it also prints a message that points the user should
enable it in the kernel if needed.

It also bundles the dst and dst_ca objects to one selectable option.
So the idea remains the same.
>From my side I do not see any problem with that patch, if someone else
has a problem with it please state out the reason.

Markus


On 4/30/07, Markus Rechberger <mrechberger@gmail.com> wrote:
> On 4/30/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
> >
> > On Apr 30 2007 19:25, Uwe Bugla wrote:
> >
> > >THIS PATCH IS DONE TO AVOID RAM WASTE FOR CASES IN WHICH IT IS PROVEN
> THAT
> > DST
> > >AND DST_CA ARE NOT NEEDED AT ALL!!!!
> > >[...]
> >
> >
> > How much on the Theo-meter are we yet?
> >
>
> it's enough, I told him that I'll look at it and try to get some other
> people involved if it really breaks something it should get stated
> out; and I'll refuse any further help if he starts to write any more
> abusive mail.
>
> So to his proposal:
>
> the whole noise is about following Makefile patch:
> -obj-$(CONFIG_DVB_BT8XX) += bt878.o dvb-bt8xx.o dst.o dst_ca.o
> +obj-$(CONFIG_DVB_BT8XX) += bt878.o dvb-bt8xx.o
> +obj-$(CONFIG_DVB_DST) += dst.o
> +obj-$(CONFIG_DVB_DST_CA) += dst_ca.o
>
> that symbol_request is unable to return a valid pointer if DST an
> DST_CA aren't selected should be ok because this would only happen if
> someone didn't compile them in (an appropriate error message should be
> added for that)
>
> I'm trying to look closer at this issue with some other developers, if
> it's really that easy to split off the dst module from the bt* objects
> without breaking anything, to me the direction this patch goes seems
> to be ok, some people stated out that there are problems so I'll try
> to get more information about that.
>
> Markus
>


-- 
Markus Rechberger
