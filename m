Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344AbYFYVJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbYFYVJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 17:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbYFYVJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 17:09:11 -0400
Received: from gw.goop.org ([64.81.55.164]:48322 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbYFYVJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 17:09:11 -0400
Message-ID: <4862B3E9.50601@goop.org>
Date: Wed, 25 Jun 2008 14:08:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: Re: [PATCH 03 of 36] x86: add memory barriers to wrmsr
References: <patchbomb.1214367536@localhost>	<93c7057b1f4acae501b2.1214367539@localhost> <20080624214441.13202f12@infradead.org>
In-Reply-To: <20080624214441.13202f12@infradead.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> it's more readable for several of these cases to stick a barrier(); in
> front and after it to be honest; that makes it more explicit that
> these are deliberate compiler barriers rather than "actual" memory
> access...
>
>   

I suppose, though I would be inclined to put the barriers in the wrmsr 
macro itself to act as documentation.  Either way, I don't think there's 
any legitimate reason to let the compiler reorder things around a wrmsr, 
and it should be an inherent property of the macro, rather than relying 
on ad-hoc barriers where it gets used.  After all, that's a fairly 
accurate reflection of how the micro-architecture treats wrmsr...

    J
