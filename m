Return-Path: <linux-kernel-owner+w=401wt.eu-S1161034AbXCGAfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161034AbXCGAfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 19:35:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161039AbXCGAfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 19:35:16 -0500
Received: from gw.goop.org ([64.81.55.164]:54161 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161037AbXCGAfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 19:35:09 -0500
Message-ID: <45EE08BA.6080309@goop.org>
Date: Tue, 06 Mar 2007 16:35:06 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 8/8] Convert PDA into the percpu section
References: <1173184747.4644.23.camel@localhost.localdomain>	 <1173185592.4644.28.camel@localhost.localdomain>	 <1173185666.4644.30.camel@localhost.localdomain>	 <1173185734.4644.32.camel@localhost.localdomain>	 <1173185827.4644.34.camel@localhost.localdomain>	 <1173185909.4644.36.camel@localhost.localdomain>	 <1173186021.4644.38.camel@localhost.localdomain>	 <1173186107.4644.41.camel@localhost.localdomain>	 <1173186214.4644.44.camel@localhost.localdomain>	 <20070306131041.GB9031@elte.hu> <1173226350.4644.54.camel@localhost.localdomain>
In-Reply-To: <1173226350.4644.54.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> 	If we used __thread, then gcc could do this optimization for us when it
> knows an rvalue is needed, however:
>
> 1) gcc wants to use %gs, not %fs, which is measurably slower for the
> kernel,
> 2) gcc wants to use huge offsets to store the address of the per-cpu
> space, and this breaks Xen (and current lguest, but new lguest no longer
> uses segments for protection)
>   

Well, if we go to the effort of teaching gcc how to use %fs, we can
probably convince it to generate positive offset TLS relocs too.

    J
