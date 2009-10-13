Return-Path: <linux-kernel-owner+w=401wt.eu-S933725AbZJMHkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933725AbZJMHkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758999AbZJMHkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:40:42 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:24086 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757330AbZJMHkl (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;7:1>);
	Tue, 13 Oct 2009 03:40:41 -0400
Message-Id: <4AD44AF10200007800019801@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 13 Oct 2009 08:40:01 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       <u.kleine-koenig@pengutronix.de>
Cc: "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Cox" <alan@linux.intel.com>,
       <linux-arm-kernel@lists.infradead.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial/atmel_serial: Fix another fallout of the
	 change to BUILD_BUG_ON
References: <1255417680-25609-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20091013092644.72c78334@hskinnemoen-d830>
In-Reply-To: <20091013092644.72c78334@hskinnemoen-d830>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Haavard Skinnemoen <haavard.skinnemoen@atmel.com> 13.10.09 09:26 >>>
>Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
>> Commit 8c87df457cb5 fixed BUILD_BUG_ON with the result that some
>> expressions (e.g. "not really constant" ones) result in a build failure.
>> 
>> Some of these were fixed in 8c87df457cb5, but not serial/atmel_serial.
>
>This patch fixes the same issue:
>
>http://lkml.org/lkml/2009/10/6/305 
>
>> -	BUILD_BUG_ON(!is_power_of_2(ATMEL_SERIAL_RINGSIZE));
>> +	MAYBE_BUILD_BUG_ON(!is_power_of_2(ATMEL_SERIAL_RINGSIZE));
>
>What's the difference between BUILD_BUG_ON() and MAYBE_BUILD_BUG_ON()?

The latter (at present) generally only serves as an annotation. It should
probably be renamed and converted to the (linking time) detecting
mechanism Rusty suggested (though I'm not sure that model would
allow all non-constant [at parsing time] uses to be detected - clearly
there would remain potential for build issues if the compiler isn't able
to reduce the expression to a constant during optimization).

Jan
