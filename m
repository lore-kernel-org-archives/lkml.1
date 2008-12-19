Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbYLSOAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbYLSOAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 09:00:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbYLSN74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 08:59:56 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:18643 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbYLSN7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 08:59:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=LjlGpyB5xXmUm87rgi/wAQi0LbIkmPwciqjiEYajJZAPvEj2ukRC4EB65qtjoCU2fV
         utDY4AZPbzTq4Uj2/TndoxbYo/FGCkni9X6wTfQL8udPsTExZCxcuvMC2s0tJQVU8VRL
         waWSwKPXNGFQ/NshfFpcK5A/RILnAaDS86HOI=
Message-ID: <84144f020812190559y2bf4ac9am695f3d35941fa7ed@mail.gmail.com>
Date: Fri, 19 Dec 2008 15:59:53 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Guennadi Liakhovetski" <lg@denx.de>
Subject: Re: [PATCH] bitmap: fix bitmap_find_free_region()
Cc: "Johannes Weiner" <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0812191413520.4536@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0812191202130.4536@axis700.grange>
	 <20081219130211.GA1560@cmpxchg.org>
	 <Pine.LNX.4.64.0812191413520.4536@axis700.grange>
X-Google-Sender-Auth: 2a3304e5cfa1b762
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2008, Johannes Weiner wrote:
>> And return -ENOSPC?

On Fri, Dec 19, 2008 at 3:18 PM, Guennadi Liakhovetski <lg@denx.de> wrote:
> So, you agree that a check should be added to bitmap_find_free_region()?
> As for details - to warn or not to warn and what error code to return,
> that can be discussed, although "No space left on device" doesn't seem to
> fit very well IMHO:-)

Yeah, but ENOMEM, on the other had, is mostly for out-of-memory
conditions so EINVAL might be more appropriate.
