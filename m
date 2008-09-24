Return-Path: <linux-kernel-owner+w=401wt.eu-S1753656AbYIXLmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbYIXLmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 07:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbYIXLme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 07:42:34 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:34176 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751602AbYIXLmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 07:42:33 -0400
Date: Wed, 24 Sep 2008 15:42:31 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <greg@kroah.com>, Timur Tabi <timur@freescale.com>,
       Li Yang <leoli@freescale.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>, linuxppc-dev@ozlabs.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] powerpc/qe: new call to revert a gpio to a
	dedicated function
Message-ID: <20080924114231.GA8469@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080924000255.GA28054@oksana.dev.rtsoft.ru> <20080924000336.GB29733@oksana.dev.rtsoft.ru> <B8BAAB1F-10B5-419D-84A7-F724A7E77F41@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <B8BAAB1F-10B5-419D-84A7-F724A7E77F41@kernel.crashing.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 11:07:00PM -0500, Kumar Gala wrote:
>
> On Sep 23, 2008, at 7:03 PM, Anton Vorontsov wrote:
>
>> qe_gpio_set_dedicated() is a platform specific function, which is used
>> to revert a pin to a dedicated function. Caller should have already
>> obtained the gpio via gpio_request().
>>
>> This is needed to support Freescale USB Host Controller.
>>
>> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
>> ---
>> arch/powerpc/include/asm/qe.h     |    1 +
>> arch/powerpc/sysdev/qe_lib/gpio.c |   46 ++++++++++++++++++++++++++++ 
>> +++++++++
>> 2 files changed, 47 insertions(+), 0 deletions(-)
>
> what do you mean by dedicated function.. be a bit clearer in the commit 
> log.

This term is from the QE spec, I didn't invent anything. ;-)

"Each pin in the I/O ports can be configured as a general-purpose
I/O signal or as a dedicated peripheral interface signal. ...many
dedicated peripheral functions are multiplexed onto the ports."

> Also, does this depend on gpio_to_chip() patch?

Yeah, the point of exported gpio_to_chip is to let us write
this function.

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
