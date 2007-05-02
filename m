Return-Path: <linux-kernel-owner+w=401wt.eu-S2993084AbXEBM1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993084AbXEBM1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 08:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993079AbXEBM1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 08:27:25 -0400
Received: from rtr.ca ([64.26.128.89]:2737 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993084AbXEBM1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 08:27:24 -0400
Message-ID: <463883AA.6060605@rtr.ca>
Date: Wed, 02 May 2007 08:27:22 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andi Kleen <ak@novell.com>
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove unnecessary irq disabling
References: <20070501213050.GD6119@redhat.com> <4637D459.2040502@rtr.ca> <20070502044424.GA7049@redhat.com> <200705021158.17759.ak@novell.com>
In-Reply-To: <200705021158.17759.ak@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>>> What does that break, or was it already broken and this fixes it?
>> I think neither. This function is only called at early bootup,
>> (start_secondary() ), and most of its callees have interrupts off anyway.
>> But maybe we do lose something. Andi, do you have a word on this?
> 
> We need to enable them somewhere, but cpu_idle will do it in the end.
> So it should be safe to drop it. I guess keeping them disabled the whole
> time will be a little safer against potential races.
> 
> I added the patch, but might want some cooking in -mm first because this
> is always fragile code.

Okay, that would have it now match how i386 does it.

-ml
