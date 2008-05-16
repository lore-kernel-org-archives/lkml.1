Return-Path: <linux-kernel-owner+w=401wt.eu-S1759408AbYEPVca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408AbYEPVca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 17:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbYEPVcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 17:32:21 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:55979 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbYEPVcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 17:32:21 -0400
Message-ID: <fa686aa40805161432w6b5243f9nb0d0c32a87d86d02@mail.gmail.com>
Date: Fri, 16 May 2008 15:32:20 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: [RFC PATCH 0/4] Describe SPI devices in the OF device tree and add mpc5200-spi driver
Cc: linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       fabrizio.garetto@gmail.com
In-Reply-To: <9e4733910805161425i2d6cc034y3377af053a4198b5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca>
	 <9e4733910805161327u4c42fd1dg5b09319d89db447c@mail.gmail.com>
	 <fa686aa40805161348t52b94956w112ef6926ff30892@mail.gmail.com>
	 <9e4733910805161425i2d6cc034y3377af053a4198b5@mail.gmail.com>
X-Google-Sender-Auth: c0ae04534da3dea0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 3:25 PM, Jon Smirl <jonsmirl@gmail.com> wrote:
> On 5/16/08, Grant Likely <grant.likely@secretlab.ca> wrote:
>> On Fri, May 16, 2008 at 2:27 PM, Jon Smirl <jonsmirl@gmail.com> wrote:
>>  > On 5/16/08, Grant Likely <grant.likely@secretlab.ca> wrote:
>>  >> This series is a set of changes to allow the slaves on an SPI bus to be
>>  >>  described in the OF device tree (useful in arch/powerpc) and adds a driver
>>  >>  that uses it (the Freescale MPC5200 SoC's SPI device).
>>  >
>>  > Right now we have SPI hooked up to PSC3. Hardware engineer is gone but
>>  > I'll see if I can get him to alter things to use the SPI controller. I
>>  > have an old mail from him where he thinks the Phytec board is missing
>>  > a signal needed to use the SPI controller.
>>
>>
>> While I'd appreciate the testing, I suspect that you really don't want
>>  to do that.  The dedicated SPI controller isn't very good.  It only
>>  does a byte at a time and so is rather slow.  A PSC is SPI mode should
>>  be better (but I haven't tried it personally it yet).
>
> What is the device tree node for PSC3 supposed to look like when it
> has both serial and spi enabled?

The *PSC3 device* cannot support both serial and SPI at the same time.
 Only one mode works at a time...

However, *PSC3 pin group* has can be configured to route both the
*PSC3 device* and the *SPI device* signal out to the board at the same
time.

Pin routing is not something that is described by the device tree.
It's viewed as a board level initialization thing, similar to how DDR
RAM initialization is viewed.  Ideally, the bootloader will write the
correct value into port_config for pin routing and Linux will never
need to touch it.  If the bootloader cannot be changed, then
board-specific platform code can be added to fixup the port_config
setting.  However, the drivers should never touch or care about pin
routing.

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
