Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbXJWUER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbXJWUER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 16:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbXJWUEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 16:04:06 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:41931 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbXJWUED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 16:04:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=lAPvZsam18lRB+JFM0Ou7Gy5FgAlbH+7VMpaR4TMDEB5bM4+vxDVE0Brr5HAUgX7pvdOesb0i3k+h5V/BbAv6UHVeCa3gJAglTnNK6mMa/FqkZqjH1XUlwuqA+bekeW/IlicFFh9T8iPiEJ8XYf320QoGjgKYroqfZjQCzPbauI=
Message-ID: <84144f020710231304h6cba8626na4ab4bec0acda7a0@mail.gmail.com>
Date: Tue, 23 Oct 2007 23:04:03 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: SLUB 0:1 SLAB (OOM during massive parallel kernel builds)
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0710231227590.19626@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071023181615.GA10377@martell.zuzino.mipt.ru>
	 <Pine.LNX.4.64.0710231227590.19626@schroedinger.engr.sgi.com>
X-Google-Sender-Auth: 80ca364ebe85cc53
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 23 Oct 2007, Alexey Dobriyan wrote:
> > With SLAB this workload never went to OOM killer.
> > With SLUB and pretty much all debugging enabled, it finishes to the end
> > (albeit slowly).
> > With SLUB and no debugging, OOM killer kicks in.

On 10/23/07, Christoph Lameter <clameter@sgi.com> wrote:
> Not sure what this is. Maybe the slowing SLUB solves the race.

What kind of race are you thinking of? What I initially thought was
that the problem is that SLUB messes up some other VM heuristics due
to different object sizes, not holding on to empty slabs, and/or page
allocator pass-through. I guess only object size is affected by
debugging, though?
