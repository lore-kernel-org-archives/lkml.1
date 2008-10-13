Return-Path: <linux-kernel-owner+w=401wt.eu-S1760722AbYJMRXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760722AbYJMRXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 13:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756475AbYJMRW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 13:22:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235AbYJMRW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 13:22:57 -0400
Date: Mon, 13 Oct 2008 10:22:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] intermediate SCSI updates
In-Reply-To: <1223909115.5566.13.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0810131017030.3288@nehalem.linux-foundation.org>
References: <1223909115.5566.13.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 13 Oct 2008, James Bottomley wrote:
>
> This represents all the pieces of SCSI which were depending on the
> already merged block tree.

Grr. And it doesn't actually compile.

  drivers/scsi/sd.c:579:27: error: macro "sd_dif_op" passed 4 arguments, but takes just 3
  drivers/scsi/sd.c: In function ¡sd_prep_fn¢:
  drivers/scsi/sd.c:578: error: ¡sd_dif_op¢ undeclared (first use in this function)
  drivers/scsi/sd.c:578: error: (Each undeclared identifier is reported only once
  drivers/scsi/sd.c:578: error: for each function it appears in.)

Hmm? Was this testedt AT ALL? It can never compile unless that idiotic 
CONFIG_BLK_DEV_INTEGRITY option is set that no sane person would set right 
now, and which is even documented to not be enabled by default:

  If in doubt, say N.

yet it looks like it has not compiled since a commit that was put in in 
the middle of September!

What part of "This is total untested crap" are we missing here?

Yeah, I'm grumpy. I expect to not be fed shit like this. It has apparently 
been rebased several times, and all apparently with no testing 
what-so-ever!

		Linus
