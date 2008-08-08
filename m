Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbYHHBdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbYHHBdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 21:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbYHHBdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 21:33:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:51864 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbYHHBdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 21:33:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=V3STwb4GCt37iXyjJlk98GMKoy93D4mP1KrZ0V4RMqWnv2TyN6H6o0e/dt4kPPxWAD
         HR9RN6AqHMNmtdimamGKmP1PQWdBz17UhqTPRtUXvG2hvRVxSvgHFmERKx1thzOQ+g1D
         k53cnXU4PIF0EoIXgPVy4lMCfWynRu0VCBqd0=
Date: Fri, 8 Aug 2008 05:33:04 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: david@lang.hm
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: why are namespaces required?
Message-ID: <20080808013304.GA27778@martell.zuzino.mipt.ru>
References: <alpine.DEB.1.10.0808071752210.892@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808071752210.892@asgard.lang.hm>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2008 at 05:54:11PM -0700, david@lang.hm wrote:
> I am taking the time to create a minimal config for some new hardware with 
> 2.6.25.15 and noticed that CONFIG_NAMESPACES is forced to Yes unless 
> embeded is selected (at which time it becomes configurable)

For one thing, it doesn't directly control any code, CONFIG_PID_NS et al do.

> why are namespaces required?

They aren't required, just one more stupid config option.

And while we're at it, data from my usual config adding _NS options
one-by-one.

	$ size vmlinux-000 vmlinux-uts-ns vmlinux-ipc-ns vmlinux-user-ns vmlinux-pid-ns 
	   text    data     bss     dec     hex filename
	2560804  217296  225280 3003380  2dd3f4 vmlinux-000
	2560948  217296  225280 3003524  2dd484 vmlinux-uts-ns	(+144)
	2561452  217296  225280 3004028  2dd67c vmlinux-ipc-ns	(+504)
	2561805  217296  225280 3004381  2dd7dd vmlinux-user-ns	(+353)
	2562819  217300  225280 3005399  2ddbd7 vmlinux-pid-ns	(+1018)

What amazing .text savings we have here.

