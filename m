Return-Path: <linux-kernel-owner+w=401wt.eu-S1757152AbYH2QYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbYH2QYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 12:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbYH2QYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 12:24:14 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:17290 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbYH2QYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 12:24:13 -0400
Subject: Re: [PATCH 4/5] select: make select() use schedule_hrtimeout()
From: Daniel Walker <dwalker@mvista.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de,
       torvalds@linux-foundation.org
In-Reply-To: <20080829080809.0e42a323@infradead.org>
References: <20080829080549.6906b744@infradead.org>
	 <20080829080809.0e42a323@infradead.org>
Content-Type: text/plain
Date: Fri, 29 Aug 2008 08:59:58 -0700
Message-Id: <1220025598.4417.63.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-29 at 08:08 -0700, Arjan van de Ven wrote:
> rom: Arjan van de Ven <arjan@linux.intel.com>
> Date: Thu, 28 Aug 2008 13:45:38 -0700
> Subject: [PATCH] select: make select() use schedule_hrtimeout()
> 
> now that we have schedule_hrtimeout(), make select() use it.
> But only for short delays; really long delays are assumed to not
> need the highres level of accuracy but rather want the regular
> timer behavior for now.
> 
> This is only done for delays shorter than 1 second; currently
> the assumption is that longer delays have no desire to get the
> higher accuracy.

Do you have any basis to make this "short delays" assumption? I would
think if regular timers can be used for longer than a second, people
will naturally assume anything else that's high res will also ..

The futex_wait() has code which looks a lot like your
schedule_hrtimeout() , (you might want to replace your code there
instead) , and it doesn't seem to have the short delays restriction ..

Daniel

