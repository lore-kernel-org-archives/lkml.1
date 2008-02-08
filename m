Return-Path: <linux-kernel-owner+w=401wt.eu-S933190AbYBHGkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190AbYBHGkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 01:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbYBHGkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 01:40:39 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:42712 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbYBHGki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 01:40:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=HJgKg7VgvSEI/tqn+1/obMx5lf/85JYJchXWBdDaJS7E7OerPVw8PbtkE2JlmGdZVyWMNJ2OWr5Do1O/CW6+lPconuJYYcTUjPAOqGVJocVK84lGNBBiIScLcTxfsxuE6pOdAgHzJLmmDozgV4qwT3yAXjmH7YfeVnkzMN3SyRc=
Message-ID: <84144f020802072240o20ae7420x2e404e731a629c24@mail.gmail.com>
Date: Fri, 8 Feb 2008 08:40:35 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH 1/2] kmemcheck v3
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       "Richard Knutsson" <ricknu-0@student.ltu.se>
In-Reply-To: <Pine.LNX.4.64.0802071530040.3845@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47AB79D4.2070605@gmail.com>
	 <Pine.LNX.4.64.0802071341500.2544@schroedinger.engr.sgi.com>
	 <19f34abd0802071412m569e4993kffb4a3af163fa16c@mail.gmail.com>
	 <Pine.LNX.4.64.0802071443440.3289@schroedinger.engr.sgi.com>
	 <19f34abd0802071518j1ffc3dafp46fcbd8d36d36f17@mail.gmail.com>
	 <Pine.LNX.4.64.0802071530040.3845@schroedinger.engr.sgi.com>
X-Google-Sender-Auth: daaf709e7f3484f7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 8, 2008 1:32 AM, Christoph Lameter <clameter@sgi.com> wrote:
> But the slab layer allocates pages < PAGE_SIZE. You need to take a fault
> right? So each object would need its own page?

No. We allocate a shadow page for each data page which we then use as
a per-byte "bitmap." For every tracked _page_ we take the page fault
always.
