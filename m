Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbYD2Xtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbYD2Xtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 19:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754734AbYD2Xti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 19:49:38 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:27832 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbYD2Xth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 19:49:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=C14ZwggdPqrYpUREuGUfcI9MhWFku129cDCyU4nMpj1fIkCg/PCVcbcRNTBni3/gjl6UaK4C/jZ7uv+mvIMKQkz47ZeA+qIuQa1pvnsYRc3HLK3LH1Whv8ixMyP0l4Euue0B1EpWYQcpJrp4bWfZjeB02FrEXYr95F+1kFJ9H1M=
Message-ID: <37219a840804291649q36638464ye2d57cf8184580a4@mail.gmail.com>
Date: Tue, 29 Apr 2008 19:49:24 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB updates and fixes for 2.6.26
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080429185009.716c3284@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080429185009.716c3284@gaivota>
X-Google-Sender-Auth: 9b9b175dcc70f550
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 5:50 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> Linus,
>
>  Please pull from:
>         ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master
>
>  For the following:
>
>    - Fixes on mtm001, mtv022, pvrusb2, ivtv, cx88 and saa7134;
>    - new board additions on saa7134 and ivtv;
>    - load tuners only when needed;
>    - reorganization of tuner drivers that are shared between DVB and V4L;
>    - Addition of a new driver for Conexant CX23418 MPEG encoder chip (cx18).

[snip]

>  Mauro Carvalho Chehab (9):
>       Rename common tuner Kconfig names to use the same
>
>  Michael Krufky (4):
>       V4L/DVB (7789): tuner: remove static dependencies on analog tuner sub-modules


Linus has already merged the changes (thank you, Linus) ... However,
there is a bug.

My "remove static dependencies on analog tuner sub-modules" patch was
applied after Mauro's "Rename common tuner Kconfig names to use the
same" patch.

My patch has conditional behavior, based on CONFIG_DVB_CORE_ATTACH,
which was renamed to CONFIG_MEDIA_ATTACH in Mauro's patch.

To fix this, we need to do:

sed -i s/"CONFIG_DVB_CORE_ATTACH"/"CONFIG_MEDIA_ATTACH"/1
drivers/media/video/tuner-core.c

The issue will cause invalid module use counts upon unloading analog
tuner modules, if CONFIG_MEDIA_ATTACH is enabled.

I would be happy to fix this myself, but Mauro's patch has not yet
been backported into the linuxtv.org repository.

Mauro, can you do the above fix and send it in to Linus?

Thanks,

Mike Krufky
