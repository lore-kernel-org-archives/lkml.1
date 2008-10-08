Return-Path: <linux-kernel-owner+w=401wt.eu-S1756386AbYJHT3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbYJHT3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 15:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754909AbYJHT2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 15:28:55 -0400
Received: from gv-out-0910.google.com ([216.239.58.186]:22095 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602AbYJHT2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 15:28:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=pnjID9TKsYpsve+aUmTPZ8IDcZaS/VZrIcSPg4qX/WV8BOUy2UzvNrlYdMhSnVktvA
         zxm3v0LsHLGNM2vUogpQxH1qrdYlc9Jznx5oqMqHMJ7aUJe/8RsQwZRZl71D7ZSPs7Av
         tLOCmaEL/mChAkYaOOqrPiSyrH0vTkxKSTAQE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH 3/4 v2] ide: Implement disk shock protection support
Date: Wed, 8 Oct 2008 20:56:33 +0200
User-Agent: KMail/1.9.10
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <87d4j2n3dn.fsf@denkblock.local> <87d4igqxlm.fsf@denkblock.local> <873ajcar3z.fsf@denkblock.local>
In-Reply-To: <873ajcar3z.fsf@denkblock.local>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810082056.33382.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 October 2008, Elias Oltmanns wrote:
> Elias Oltmanns <eo@nebensachen.de> wrote:
> > Elias Oltmanns <eo@nebensachen.de> wrote:
> >> Hi Bart,
> >>
> >> may I ask you to apply yet another inter-diff? This is in order to
> >> address three issues:
> >>
> >> 1. Make sure that no negative value is being passed to
> >>    jiffies_to_msecs() in ide_park_show().
> >> 2. Drop the superfluous variable hwif in ide_special_rq().
> >> 3. Skip initialisation of task and tf in ide_special_rq() if we are not
> >>    handling a (un)park request.
> >
> > Well, #3 should have been done differently because we donn't want to
> > check for REQ_(UN)?PARK_HEADS more often than is necessary.
> 
> While preparing the backport to 2.6.27, it has just occurred to me that
> we need to clear the IDE_DFLAG_PARKED flag in ide_disk_pre_reset()
> because this flag must not be set after *any* sort of access to the
> device.
> 
> So, here is yet another revised version of the inter-diff. Just don't
> hurry to apply in case I have an enlightening dream tonight and want to
> change something more ;-).
> 
> Regards,
> 
> Elias
> 
> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>

I merged this version into the original patch.

[ Since it seems that there were no more enlightening dreams... ;) ]
