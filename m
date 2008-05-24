Return-Path: <linux-kernel-owner+w=401wt.eu-S1760532AbYEXGyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760532AbYEXGyk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 02:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbYEXGya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 02:54:30 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:54629 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbYEXGya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 02:54:30 -0400
Message-ID: <fa686aa40805232354g147acfcdx4753fce1a448ceb7@mail.gmail.com>
Date: Sat, 24 May 2008 00:54:29 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH 2/4] spi: split up spi_new_device() to allow two stage registration.
Cc: linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, fabrizio.garetto@gmail.com,
       jonsmirl@gmail.com
In-Reply-To: <fa686aa40805232343x20031560j5659d203e25f494@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca>
	 <20080516193608.28030.34968.stgit@trillian.secretlab.ca>
	 <200805211717.13206.david-b@pacbell.net>
	 <fa686aa40805232343x20031560j5659d203e25f494@mail.gmail.com>
X-Google-Sender-Auth: 492f82f3b705bcc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 12:43 AM, Grant Likely
<grant.likely@secretlab.ca> wrote:
> On Wed, May 21, 2008 at 6:17 PM, David Brownell <david-b@pacbell.net> wrote:
>> On Friday 16 May 2008, Grant Likely wrote:
>>>
>>> This patch splits the allocation and registration portions of code out
>>> of spi_new_device() and creates three new functions; spi_alloc_device(),
>>> spi_register_device(), and spi_device_release().
>>
>> I have no problem with the first two, but why the last?
>>
>> If the devices are always allocated by spi_alloc_device() as
>> they should be -- probably through an intermediary -- the
>> only public function necessary for that cleanup should be
>> the existing spi_dev_put().
>
> Ah, okay.  I'm still a bit fuzzy on the device model conventions.
> I'll remove that then.

Question:  spi_alloc_device() (and the original code) does a
spi_master_get() on the spi_master device.  Doesn't spi_master_put()
need to be called when the device is discarded?  spi_dev_put() doesn't
do that explicitly; is it an implicit operation after a device has
been deregistered from the spi_master?

Thanks,
g.

>
> g.
>
> --
> Grant Likely, B.Sc., P.Eng.
> Secret Lab Technologies Ltd.
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
