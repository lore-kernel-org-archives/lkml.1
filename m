Return-Path: <linux-kernel-owner+w=401wt.eu-S1752550AbZK0CDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbZK0CDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 21:03:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbZK0CDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 21:03:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:60323 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbZK0CDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 21:03:06 -0500
Message-ID: <4B0F3331.3070107@kernel.org>
Date: Fri, 27 Nov 2009 11:02:25 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: linux-next: workqueues tree build failure
References: <20091126190050.3f9d7fef.sfr@canb.auug.org.au>	 <4B0E3677.6000603@kernel.org> <200911261016.58810.peter.ujfalusi@nokia.com>	 <4B0E467A.8080201@kernel.org> <1259239225.3062.16.camel@palomino.walls.org>
In-Reply-To: <1259239225.3062.16.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

11/26/2009 09:40 PM, Andy Walls wrote:
>> * If you need to respond fast, wouldn't you be doing that from IRQ
>>   handler or softirq?  Do you need task context?
> 
> I'm not sure doing things like I2C transactions in the in the top half
> of the IRQ handler is generally viable.  On shared IRQ lines, wouldn't
> this hold off the interrupt for another device for too long?
> 
> For example, I already ran across the case of an error path in the ahci
> disk controller driver interrupt handler holding off interrupts from the
> cx18 driver longer than the CX23418 firmware would tolerate on a shared
> interrupt line.

Sounds like it should be using bottom half tasklet not workqueue.
Tasklet is exactly designed to handle situations like this.  Is there
any reason tasklet can't be used?

Thanks.

-- 
tejun
