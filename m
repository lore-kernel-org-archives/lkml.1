Return-Path: <linux-kernel-owner+w=401wt.eu-S932526AbYGOAlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526AbYGOAlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 20:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757614AbYGOAlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 20:41:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52581 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757421AbYGOAlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 20:41:10 -0400
Date: Mon, 14 Jul 2008 17:40:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: david@lang.hm, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <1216082213.27455.109.camel@shinybook.infradead.org>
Message-ID: <alpine.LFD.1.10.0807141738360.3017@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>  <20080714164119.99c33d5b.akpm@linux-foundation.org>  <20080714165956.7fe2d4ee@infradead.org>  <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm>
 <1216082213.27455.109.camel@shinybook.infradead.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, David Woodhouse wrote:
> 
> I see no real point in that. If you have userspace to load modules, then
> you have userspace to load firmware.

David, the case is different: the module is loaded _across_ the 
suspend/resume, but the device needs to have its firmware reloaded at 
resume time because it lost power.

And since the device may be resumed before the root filesystem disk 
device, it needs to do so _without_ calling request_firmware() at resume 
time.

The above is _normal_.

And the fact is, the only way to handle it sanely is to do the 
request_firmware() before suspending.

I _really_ don't understand why this keeps coming up all the time. It's a 
no-brainer, with a single possible solution, yet people continue to whine 
about it.

			Linus
