Return-Path: <linux-kernel-owner+w=401wt.eu-S1422763AbXBUSWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422763AbXBUSWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:22:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422765AbXBUSWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:22:12 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:1600 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422763AbXBUSWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:22:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=HCxYjtxqxNpnRg55U+AO8ckhOTFrugpMBYc46dhhvva2pziFmN+j+OMZktM4mBXzLrsk943EflgJK52SeEr2uJA/uWNbwj8OApP3x0tCSYezOtOlFxTMo5sR5lUcg7BuFjrGTenmu/K/MgOXSfRhcg2/ik4yvLC8crS4Nsl3z34=
Message-ID: <84144f020702211022h10dd36c4n74837169a7b211ef@mail.gmail.com>
Date: Wed, 21 Feb 2007 20:22:08 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH] slab: ensure cache_alloc_refill terminates
Cc: akpm@linux-foundation.org, mcr@sandelman.ca, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0702210950310.24344@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0702211029340.9758@sbz-30.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0702210950310.24344@schroedinger.engr.sgi.com>
X-Google-Sender-Auth: e9201ace4f5b08d7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Feb 2007, Pekka J Enberg wrote:
> > +              */
> > +             BUG_ON(slabp->inuse < 0 || slabp->inuse >= cachep->num);
> > +
> >               while (slabp->inuse < cachep->num && batchcount--) {

On 2/21/07, Christoph Lameter <clameter@sgi.com> wrote:
> I think you only need to check for <0. If slabp->inuse > cachep->num then
> the loop will not be taken.

...and batchcount is not decremented and we're effectively in an
infinite loop. Or am I missing something here?
