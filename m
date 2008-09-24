Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbYIXOBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbYIXOBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 10:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbYIXOBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 10:01:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:35114 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbYIXOBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 10:01:31 -0400
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <greg@kroah.com>, Timur Tabi <timur@freescale.com>,
       Li Yang <leoli@freescale.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>, linuxppc-dev@ozlabs.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <E8A37756-794A-4829-ABEC-AACA9DB54620@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: avorontsov@ru.mvista.com
In-Reply-To: <20080924114231.GA8469@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [PATCH 2/4] powerpc/qe: new call to revert a gpio to a dedicated function
Date: Wed, 24 Sep 2008 09:00:03 -0500
References: <20080924000255.GA28054@oksana.dev.rtsoft.ru> <20080924000336.GB29733@oksana.dev.rtsoft.ru> <B8BAAB1F-10B5-419D-84A7-F724A7E77F41@kernel.crashing.org> <20080924114231.GA8469@oksana.dev.rtsoft.ru>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 24, 2008, at 6:42 AM, Anton Vorontsov wrote:

> On Tue, Sep 23, 2008 at 11:07:00PM -0500, Kumar Gala wrote:
>>
>> On Sep 23, 2008, at 7:03 PM, Anton Vorontsov wrote:
>>
>>> qe_gpio_set_dedicated() is a platform specific function, which is  
>>> used
>>> to revert a pin to a dedicated function. Caller should have already
>>> obtained the gpio via gpio_request().
>>>
>>> This is needed to support Freescale USB Host Controller.
>>>
>>> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
>>> ---
>>> arch/powerpc/include/asm/qe.h     |    1 +
>>> arch/powerpc/sysdev/qe_lib/gpio.c |   46 ++++++++++++++++++++++++++ 
>>> ++
>>> +++++++++
>>> 2 files changed, 47 insertions(+), 0 deletions(-)
>>
>> what do you mean by dedicated function.. be a bit clearer in the  
>> commit
>> log.
>
> This term is from the QE spec, I didn't invent anything. ;-)
>
> "Each pin in the I/O ports can be configured as a general-purpose
> I/O signal or as a dedicated peripheral interface signal. ...many
> dedicated peripheral functions are multiplexed onto the ports."

I understand but I think 'dedicated' could be interpreted in another  
way (like the GPIO pin is dedicated, not that the pin is used for a  
dedicated SoC block).

If it the commit message had said 'to a dedicated on chip peripheral'  
it would be clearer.

>> Also, does this depend on gpio_to_chip() patch?
>
> Yeah, the point of exported gpio_to_chip is to let us write
> this function.

I meant can I take this patch w/o the gpio_to_chip() patch? (not clear  
from your response)

- k
