Return-Path: <linux-kernel-owner+w=401wt.eu-S1766985AbXEBUfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766985AbXEBUfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 16:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766993AbXEBUfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 16:35:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:9257 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766985AbXEBUft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 16:35:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=c6rCUMZJU7Ir7WxXpMH7EdIOzSXYdD1wE+UNcIL1/KjQkrpjiieI7Ksvzg99XlzXnOA6YY8hKbKEd2V8yLxXtV+snDkmCjiNv3iBPCv1d443M2UWYG8kvX8iPpxcth5m6lB5PIV0c/rNL+gUHHCzPYWk7HgEfeb00MCYosPEALY=
Message-ID: <84144f020705021335i42473caei8f5421e91fd904dd@mail.gmail.com>
Date: Wed, 2 May 2007 23:35:38 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 1/6] firewire: handling of cards, buses, nodes
Cc: linux-kernel@vger.kernel.org, "Kristian H??gsberg" <krh@redhat.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       "Christoph Hellwig" <hch@infradead.org>
In-Reply-To: <4638E379.4050401@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4637A29F.6070302@redhat.com>
	 <20070502090007.GA28174@infradead.org>
	 <tkrat.087ee29add656926@s5r6.in-berlin.de>
	 <tkrat.350cb4dfe522266e@s5r6.in-berlin.de>
	 <84144f020705020855q6e68381el899261fa30f60cc4@mail.gmail.com>
	 <4638E379.4050401@s5r6.in-berlin.de>
X-Google-Sender-Auth: 048f10ee58b0c329
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> I looked around a bit with grep -R and a few search terms but didn't
> find something definite.  Is there any other user of a crc16_itu_t or
> crc_ccitt or whatever which operates on a (CPU byte ordered) u32[]
> instead of on a (network byte ordered) u8[]?

I was referring to this: http://lkml.org/lkml/2006/6/12/137

On 5/2/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> The only value in having a shared implementation would be a potentially
> smaller kernel.  Sharing it to ensure correctness is not an issue;
> fw-topology.c::crc16_itu_t is simply the one in IEEE 1212 table 5.
> Performance is also not an issue (if better algorithms exist) because
> the FireWire stack uses it only infrequently on a moderate amount of data.

Yeah, it's not a biggie, but we do have a tradition of putting
generally useful things into lib/ so that everyone doesn't invent
their own.
