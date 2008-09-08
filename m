Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbYIHXA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbYIHXA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 19:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbYIHXAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 19:00:50 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54780 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752492AbYIHXAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 19:00:50 -0400
Subject: Re: [PATCH] fix RTC_CLASS regression with PARISC
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: David Miller <davem@davemloft.net>
Cc: david-b@pacbell.net, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org
In-Reply-To: <20080908.143504.121592746.davem@davemloft.net>
References: <200809081213.37705.david-b@pacbell.net>
	 <1220905689.8074.68.camel@localhost.localdomain>
	 <200809081429.57805.david-b@pacbell.net>
	 <20080908.143504.121592746.davem@davemloft.net>
Content-Type: text/plain
Date: Mon, 08 Sep 2008 18:00:47 -0500
Message-Id: <1220914847.8074.81.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-08 at 14:35 -0700, David Miller wrote:
> From: David Brownell <david-b@pacbell.net>
> Date: Mon, 8 Sep 2008 14:29:57 -0700
> 
> > On Monday 08 September 2008, James Bottomley wrote:
> > > All the PDC real time clock calls can do are read and set, nothing else,
> > > so it's idealy suited to the GEN_RTC infrastructure ... what's the
> > > benefit in moving it to RTC_CLASS?
> > 
> > The same benefit always found in sharing infrastructure.  Lots
> > of little differences/bugs go away.  Infrastructure improvements
> > and bugfixes get leveraged.  Dead and crufticious code can vanish.
> > And so forth.
> 
> I absolutely and positively agree with David here.
> 
> I just last week converted all of both sparc ports to the generic
> RTC layer and what a huge burdon has been moved off of my shoulders.
> 
> The RTC layer is very nice and it even allows writing drivers for
> very simplistic RTC devices (even ones that cannot be written)
> with ease.  I had two such cases to handle on sparc64.

I'm guessing they're not upstream yet (since I can't find them)?

However, if you based them on rtc-ppc.c then yes, I agree, it looks
reasonably easy:  it's just a matter of converting over the GEN_RTC
PDT_TOD helpers.

On a related note ... I could do this specifically for parisc, but I
could also do a GEN_RTC conversion to PDC_CLASS ... would that be more
helpful?

James


