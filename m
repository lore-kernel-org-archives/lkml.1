Return-Path: <linux-kernel-owner+w=401wt.eu-S965451AbXCLJsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965451AbXCLJsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 05:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965452AbXCLJsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 05:48:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48759 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965451AbXCLJsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 05:48:10 -0400
Date: Mon, 12 Mar 2007 10:48:05 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       "Marcin 'Qrczak' Kowalczyk" <qrczak@knm.org.pl>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: _proxy_pda still makes linking modules fail
Message-ID: <20070312094805.GA11644@one.firstfloor.org>
References: <1173315479.12472.9.camel@qrnik> <p73lki39s3a.fsf@bingen.suse.de> <45F49E0A.3090607@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F49E0A.3090607@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2007 at 05:25:46PM -0700, Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> > Hmm, it probably needs a EXPORT_SYMBOL. The previous change only
> > fixed the in kernel build.
> >
> > Does it work with this patch?
> >
> > -Andi
> >
> > Export _proxy_pda for gcc 4.2
> >   
> 
> Gak.  It seemed like such a good idea at the time.

The problem is that the upcomming 4.2 has a more aggressive optimizer
and when there are two "m" (_proxy_pda...) references in the same
function it CSEs its address into a register. And that generates
code and a reference.

> 
> Rusty's pda->per_cpu patch will deal with this once and for all; have

Not on x86-64.

> you picked it up yet?

Not yet.

-Andi
