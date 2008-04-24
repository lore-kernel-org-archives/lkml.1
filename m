Return-Path: <linux-kernel-owner+w=401wt.eu-S1764936AbYDXPru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764936AbYDXPru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759008AbYDXPrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:47:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58051 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbYDXPri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:47:38 -0400
Date: Thu, 24 Apr 2008 12:47:08 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Frank Bennett" <biercenator@gmail.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "Michael Krufky" <mkrufky@linuxtv.org>,
       "Hans Verkuil" <hverkuil@xs4all.nl>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, ivtv-devel@ivtvdriver.org
Subject: Re: [PATCH] Fix VIDIOCGAP corruption in ivtv
Message-ID: <20080424124708.3169448a@gaivota>
In-Reply-To: <53208a5f0804231226n3cf04ea5ja3cebb5584886183@mail.gmail.com>
References: <20080420122736.20d60eff@the-village.bc.nu>
	<200804201806.33464.hverkuil@xs4all.nl>
	<480B6AD8.9090404@linuxtv.org>
	<20080423143454.0d50b209@gaivota>
	<53208a5f0804231226n3cf04ea5ja3cebb5584886183@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frank/Alan,

On Thu, 24 Apr 2008 04:26:46 +0900
"Frank Bennett" <biercenator@gmail.com> wrote:

> Maruo,
> 
> I don't want to make your life more complicated than necessary, but
> while we're on the topic of attribution ...
> 
> The real work in identifying this issue was done by Andrew Macks, the
> engineer at Skype. My role in the affair consisted of complaining,
> sending along a log file, recompiling the kernel, and writing an email
> message.
> 
> I relayed the initial response I received from Hans Verkuil to Andrew
> (via skype chat, I do not have an email address for him), to let him
> know that the problem was being addressed in the kernel, and he was
> glad to hear the news. But watching things unfold, I have been feeling
> slightly incomfortable that only my name might end up in the chain of
> correspondence, and not his.  I would just like to slip in a note here
> to that effect.

Maybe we can just add his name in parenthesis. Would this patch description be
ok for you, Andrew and Alan?

Fix VIDIOCGAP corruption in ivtv

From: Alan Cox <alan@redhat.com>

Frank Bennett reported that ivtv was causing skype to crash. With help
from one of their developers (Andrew Macks) he showed it was a kernel problem.
VIDIOCGCAP copies a name into a fixed length buffer - ivtv uses names
that are too long and does not truncate them so corrupts a few bytes of
the app data area.

Possibly the names also want trimming but for now this should fix the
corruption case.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>

Cheers,
Mauro
