Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbXJWUlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbXJWUlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 16:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbXJWUlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 16:41:44 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:41004 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbXJWUln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 16:41:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Bu7YGpJ/YT9yOv2ouL2faniaftu3Zctibyux7CPLbRxswx7vApbwVR/XIgSGWhKGxrsgxrVbSKBv24LxtUPmq1LSMqHtJSCbzKXDRPHZXClWAeYAW7kkfZcUFjExyxdCwlLXO40OxNSgUSzBdY7fMATgPhHvfJthAeoEESa9L7Q=
Message-ID: <84144f020710231341p189435b1y5514e5be981b9b1c@mail.gmail.com>
Date: Tue, 23 Oct 2007 23:41:42 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: SLUB 0:1 SLAB (OOM during massive parallel kernel builds)
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       "Linux MM" <linux-mm@kvack.org>
In-Reply-To: <Pine.LNX.4.64.0710231305050.20095@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071023181615.GA10377@martell.zuzino.mipt.ru>
	 <Pine.LNX.4.64.0710231227590.19626@schroedinger.engr.sgi.com>
	 <84144f020710231304h6cba8626na4ab4bec0acda7a0@mail.gmail.com>
	 <Pine.LNX.4.64.0710231305050.20095@schroedinger.engr.sgi.com>
X-Google-Sender-Auth: 243e0ef8ff04a1ea
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

(I fixed linux-mm cc to kvack.org.)

On 10/23/07, Christoph Lameter <clameter@sgi.com> wrote:
> The number of objects per page is reduced by enabling full debugging. That
> triggers a potential of more order 1 allocations but we are failing at
> order 0 allocs.

Yeah, but we're _not failing_ when debugging is enabled. Thus, it's
likely, that the _failing_ (non-debug) case has potential for more
order 0 allocs, no? I am just guessing here but maybe it's
slab_order() behaving differently from calculate_slab_order() so that
we see more order 0 pressure in SLUB than SLAB?

                                     Pekka
