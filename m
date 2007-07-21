Return-Path: <linux-kernel-owner+w=401wt.eu-S937046AbXGUKXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937046AbXGUKXF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 06:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760375AbXGUKWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 06:22:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:46216 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759100AbXGUKWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 06:22:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YzDbozBSO+PH7Lirh7QnzgPrrpzT5MgU3BfXvV9qddOiEdjNVz91coBKnbliZozbIRQL0EuSshlI8I/HEsbivQ0EKOkYNwU1TIqK1qEPzMf0Cw177dnE77AaLTmjSmzzut9s221ufr4e13vDCkTZlpV11Hj02pU2r57OsF1PWj8=
Message-ID: <92a12cdb0707210322m6670acaer768d078c5e358b0c@mail.gmail.com>
Date: Sat, 21 Jul 2007 11:22:53 +0100
From: "Adrian McMenamin" <adrianmcmenamin@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix DMA on Dreamcast
Cc: linux-kernel@vger.kernel.org, lethal@users.sourceforge.net
In-Reply-To: <20070720120408.1f190269.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <92a12cdb0707191230g216feaf2ied3e95bacf4dd572@mail.gmail.com>
	 <20070720120408.1f190269.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/07/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 19 Jul 2007 20:30:34 +0100
> "Adrian McMenamin" <adrianmcmenamin@gmail.com> wrote:
>
> > I think my first attempt to post this may have got lost in space somewhere.
> >
> > Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
>
> Please provide a description of what problem this change is solving, and how
> it solves it.
>
Andrew

Sorry, just noticed this. Without this patch the Dreamcast won't boot
when configured with the correct DMA settings in Kbuild. You can
either patch the kernel or use the wrong settings in the build.

Essentially the SH DMA API code is broken in that it doesn't correctly
match the DMA virtual channel to the DMAC.

The patch seems to fix this, though further testing has reveled there
may either be an issue with the patch or an issue with other drivers
using DMA and which have worked because they inadvertently relied on
the breakage in the DMA API code.
