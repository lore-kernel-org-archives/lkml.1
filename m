Return-Path: <linux-kernel-owner+w=401wt.eu-S932113AbZJSOcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbZJSOcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 10:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756404AbZJSOcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 10:32:39 -0400
Received: from ozlabs.org ([203.10.76.45]:58989 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756381AbZJSOcg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 10:32:36 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Jan Beulich" <JBeulich@novell.com>
Subject: Re: [PATCH] serial/atmel_serial: Fix another fallout of the change to BUILD_BUG_ON
Date: Tue, 20 Oct 2009 01:02:29 +1030
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Cox" <alan@linux.intel.com>, linux-arm-kernel@lists.infradead.org,
       u.kleine-koenig@pengutronix.de, linux-kernel@vger.kernel.org
References: <1255417680-25609-1-git-send-email-u.kleine-koenig@pengutronix.de> <200910191638.41299.rusty@rustcorp.com.au> <4ADC3D3C020000780001AA10@vpn.id2.novell.com>
In-Reply-To: <4ADC3D3C020000780001AA10@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200910200102.30478.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Oct 2009 06:49:40 pm Jan Beulich wrote:
> >>> Rusty Russell <rusty@rustcorp.com.au> 19.10.09 08:08 >>>
> >How's this?  It's not quite valid C, but it "works":
> 
> But that's not what you proposed initially, i.e. generating a link time
> error if a compile time error can't be generated (and only if even a link
> time error isn't possible, a run time one should be forced).

Yeah, this was cleverer.  A compile time is nicer than link time.  And this
is *actually* what I want: a compile fail if the compiler knows enough, runtime
otherwise.

> And btw., why do you think this isn't valid C?

>From my glance at ISO C, non-positive sized variable length arrays are
invalid.  gcc here seems to give the expected results (eg. sizeof gives
a negative result).

Cheers,
Rusty.
