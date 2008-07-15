Return-Path: <linux-kernel-owner+w=401wt.eu-S1760644AbYGOAfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760644AbYGOAfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 20:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755952AbYGOAex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 20:34:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755507AbYGOAew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 20:34:52 -0400
Date: Mon, 14 Jul 2008 17:33:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: david@lang.hm
cc: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm>
Message-ID: <alpine.LFD.1.10.0807141729200.3017@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, david@lang.hm wrote:
> 
> there was also the issue that was raised about how to handle firmware during
> suspend/resume. I don't remember seeing a happy solution to that one.

I don't understand why this even keeps coming up.

The only reliable way to handle it is to load the firmware before the 
suspend happens - preferably by simply never unloading it in the first 
place.

Anything else is fraught with problems.

Stuff that expects to eject itself anyway(*) over a suspend event can 
obviously decide to throw it away and require a reload at resume time (by 
virtue of simply re-discovering the whole device!).

Everybody else should just keep the firmware in memory in the driver.

Does it waste some ram? Sure. Tough. 

			Linus

(*) eg some random USB device that really _really_ doesn't care and isn't 
expected to be involved in any filesystem access - say a webcam.

