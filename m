Return-Path: <linux-kernel-owner+w=401wt.eu-S1762408AbXEVA0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762408AbXEVA0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 20:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757349AbXEVA0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 20:26:33 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:36110 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756895AbXEVA0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 20:26:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nLC30hNdL++jtRTAT5OI3XH7/pys/7thZL6++CWKP3yKkmiuYmyIjjwsbNoKUrjbUYp3lykSlC9nFiwmo7DsvNrkiYcP32z+K5grWp5XuLMvYeCtGlR0M4pxygEqStsAiomkrWgwYiRBWM70emWO259bTLXngzZo3CmWqhijyik=
Message-ID: <9e4733910705211726q38be6843ndac49f8adc25aad0@mail.gmail.com>
Date: Mon, 21 May 2007 20:26:30 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <465228E2.1030405@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705171423.46748.jesse.barnes@intel.com>
	 <9e4733910705210901v5996cacas640f211404c519c6@mail.gmail.com>
	 <200705210914.22663.jbarnes@virtuousgeek.org>
	 <200705210934.58559.jbarnes@virtuousgeek.org>
	 <9e4733910705211005k761c976o1a6b270d87b49589@mail.gmail.com>
	 <465228E2.1030405@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Jeff Garzik <jeff@garzik.org> wrote:
> Jon Smirl wrote:
> > 2) Address the long outstanding issue of multi-seat at the console
> > level. My solution to this is the one device per CRTC model.
>
> This is very very low priority.  Pretty much nobody besides you is
> clamoring for it.
>
>
> > 3) Eliminate the need for a root priv controlling process. Get rid of
> > the potential for a security hole.
>
> Agreed.
>
>
> > 4) OOPS should always display even if in a graphics mode
>
> Agreed, and this was in the list that Jesse(?) posted.
>
>
> > 8) Allow multiple user space graphics systems to run. These user space
>
> Another very very low priority item.
>
> There are a lot more important things to work on.  Linux is about what
> people need -right now-, not what you think Linux might need in the
> future; not what you think might be nice to have.

I am not asking that these features be implemented today. I am asking
that enough planning go into the architecture today to make sure that
these features can be built in the future without tearing up the
graphics system for a third time.

This is the essence of my complaint about this patch. The patch
introduces a new low level graphics API to the kernel. Once we put an
API in it is basically impossible to get it back out. I am not
convinced that enough planning has gone into this API yet.

I'm also not convinced that there is a transition plan in place to
ensure that all drivers get updated to this new API. The last thing we
want is to maintain two parallel sets of video drivers forever into
the future. V4L2 did something similar to this and orphaned a lot of
drivers that the distributions were forced into updating later.

Mode setting is intimately intertwined with the console. VT swapping
adds another messy layer which can and should be eliminated in a
redesign. Multi-seat and unicode add more complexity. All of this
needs to be designed as a unified system. Satisfying the needs of the
X server is the easiest piece of the puzzle.

-- 
Jon Smirl
jonsmirl@gmail.com
