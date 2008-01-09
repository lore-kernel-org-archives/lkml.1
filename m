Return-Path: <linux-kernel-owner+w=401wt.eu-S1757878AbYAICai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbYAICai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 21:30:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbYAICa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 21:30:29 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:3426 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967AbYAICa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 21:30:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=DutduvZjzzcAMhP5zY7cIMpETEWfOJTJ4/gM3YniT6AHeJOLeilTeu0u/KkMJQST2S8kkTX/tU9wZ5jzN5cnQw/H4osOKYXoTXc/NuEYYkRIe0DZJPQAaDGbUzd6JM15K1SZ75pPX+d5OWNjXhffaKH72nTmuM368S+hmDPvWHI=
Message-ID: <478431BD.4030109@gmail.com>
Date: Wed, 09 Jan 2008 11:30:21 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linda Walsh <lkml@tlinx.org>
CC: Mikael Pettersson <mikpe@it.uu.se>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Believed resolved: SATA kern-buffRd read slow: based on promise
 driver bug
References: <fa.6TIOCGhBpW0r4XW9rqR+Ad8P+Js@ifi.uio.no>	<4777E08C.4000603@shaw.ca>	<4779870E.5070507@tlinx.org>	<20080101015812.59e9ebf0@the-village.bc.nu>	<477BEF8D.8090307@tlinx.org>	<477C2B71.7040504@shaw.ca>	<477C63AA.8080006@tlinx.org>	<18300.40661.199761.488061@harpo.it.uu.se>	<477D9C00.8060600@tlinx.org> <18302.5940.173422.967902@harpo.it.uu.se> <47813835.3020508@tlinx.org>
In-Reply-To: <47813835.3020508@tlinx.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linda Walsh wrote:
>    Is 'main' diff between NCQ/TCQ that TCQ can re-arrange 'write'
> priority under driver control, whereas NCQ is mostly a FIFO queue?

No, NCQ can reorder although I recently heard that windows issues
overlapping NCQ commands and expects them to be processed in order (what
were they thinking?).

The biggest difference between TCQ and NCQ is that TCQ is for SCSI while
NCQ is for ATA.  Functional difference includes more number of available
tags and ordered tags for TCQ.  The former doesn't matter for single
disk.  The latter may make some difference but on single disk not by much.

> Am trying to differentiate NCQ/TCQ and SAS v. SCSI benefits.
> It seems both support (SAS & SATA) some type of port-multiplier/
> multiplexor/ option to allow more disks/port.
> 
> However, (please correct?) SATA uses a hub type architecture while
> SAS uses a switch architecture.  My experience with network hubs vs.
> switches is that network hubs can be much slower if there is
> communication contention.  Is the word 'hub' being used in the
> "shared-communication media sense", or is someone using the term
> 'hub' as a [sic] replacement for a 'switch'?

Port multiplier is a switch too.  It doesn't broadcast anything and
definitely has forwarding buffers inside.  An allegory which makes more
sense is expander to router and port multiplier to switch.  Unless you
wanna nest them, they aren't that different.

-- 
tejun
