Return-Path: <linux-kernel-owner+w=401wt.eu-S1757887AbYE0PIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbYE0PIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 11:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756214AbYE0PIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 11:08:38 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:36843 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124AbYE0PIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 11:08:38 -0400
Subject: Re: [PATCH] net: wireless: airo semaphore to mutex
From: Daniel Walker <dwalker@mvista.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linville@tuxdriver.com,
       rusty@rustcorp.com.au, mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, arjan@infradead.org
In-Reply-To: <1211896108.1746.3.camel@localhost.localdomain>
References: <20080522232103.120033152@mvista.com>
	 <20080527131325.GJ30894@parisc-linux.org>
	 <1211896108.1746.3.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 27 May 2008 08:08:35 -0700
Message-Id: <1211900915.18130.251.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-27 at 09:48 -0400, Dan Williams wrote:
> 
> Yeah, that might be the right way to go.  If you want to jump into the
> driver, feel quite free, but I don't think you need to go into too much
> detail with it.  Your overall behavior analysis is right on the mark
> already.

I think we could just remove the trylock from the interrupt case, and
always force the wake_up_interruptible(&priv->thr_wait) case. It looks
like the trylocking is just an optimization to save a wakeup ..

Daniel

 

