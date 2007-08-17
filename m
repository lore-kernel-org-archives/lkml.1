Return-Path: <linux-kernel-owner+w=401wt.eu-S1761230AbXHQHtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761230AbXHQHtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 03:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756750AbXHQHte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 03:49:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756766AbXHQHtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 03:49:33 -0400
Message-ID: <46C552FB.4000508@redhat.com>
Date: Fri, 17 Aug 2007 09:49:15 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Robin Getz <rgetz@blackfin.uclinux.org>, linux-kernel@vger.kernel.org
Subject: Re: Early printk behaviour
References: <200708152234.06734.rgetz@blackfin.uclinux.org>	 <46C4009F.9090206@redhat.com> <8bd0f97a0708160947x3bd308abmc4f3b523e2444586@mail.gmail.com>
In-Reply-To: <8bd0f97a0708160947x3bd308abmc4f3b523e2444586@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
>> Hmm, sort of, although I didn't think about the case of no real console
>> replacing the early console.  The intention of the patch is to have a
>> smooth handover from the boot console to the real console.  And, yes, if
>> no real console is ever registered the boot console keeps running ...
> 
> i think it also occurs in the case where real console != early console

No.  At least not of the boot console has the CON_BOOT flag set as it
should.  Last message you'll see on the boot console is the handover
printk, telling you which real console device prints the following
messages.  Whenever early and real console go to the physical device or
not doesn't matter.

>> So you can either let it running and *not* mark it __init, so it can
>> keep on going without breaking.  Or you can explicitly unregister your
>> boot console at some point, maybe using a late_initcall.
> 
> wouldnt a common kernel late_initcall() be more appropriate ?  if
> early console hasnt switched over (for whatever reason), then kill it

Hmm, yes, should be doable in generic code.  Check whenever the current
console has CON_BOOT set and if so unregister it.

cheers,

  Gerd

