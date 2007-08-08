Return-Path: <linux-kernel-owner+w=401wt.eu-S937404AbXHHVOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937404AbXHHVOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 17:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763241AbXHHVNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 17:13:55 -0400
Received: from waikiki.ops.eusc.inter.net ([84.23.254.155]:54299 "EHLO
	waikiki.ops.eusc.inter.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764774AbXHHVNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 17:13:54 -0400
X-Trace: 4d7c73656261737469616e2e6b6c6f736b6140736e6166752e64657c38352e3137
	382e39372e36347c31494973716d2d30303031707a2d4c487c3131383636303736
	3332
Message-ID: <46BA320E.1030608@snafu.de>
Date: Wed, 08 Aug 2007 23:13:50 +0200
From: Oncaphillis <oncaphillis@snafu.de>
Reply-To: oncaphillis@snafu.de
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: UART misbehaves under Linkstation/KuroBoxHG
References: <46B9CE82.1050000@snafu.de> <Pine.LNX.4.60.0708082219520.6767@poirot.grange>
In-Reply-To: <Pine.LNX.4.60.0708082219520.6767@poirot.grange>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski wrote:
> On Wed, 8 Aug 2007, Oncaphillis wrote:
> 
>> Greetings,
>>
>> I'm trying to compile a 2.6.2x kernel on a Linkstation/KuroBox HG/ppc
>> following instructions given under
>> http://www.kurobox.com/mwiki/index.php/Kurobox_support_in_stock_2.6_kernels
> 
> Wow, congratulations! Not too many endevour into this land, and even fewer 
> succeed:-) You'd probably be better off asking this on linuxppc-dev, but 
> anyway...
> 

  Thank you very much indeed. I'm kind of proud too that I dared to enter
  this dark realm without bricking the system (at least up until now).
  And thanks for the tip. I'll give it a try.

>> and get weired settings and errors from the serial device (UART 16550A).
>>
>> Under the 2.4.17 kernel provided by the Kurobox manufacturer it gets IRQS in
>> the range of 137/138 under 2.6.22 for the linkstation it gets IRQS 17/18 and
>> the serial device behaves fishy
> 
> That interrupt numbers are different as under 2.4 is correct, however, I 
> get 16 and 17 for ttyS0 and ttyS1 on a kuroboxHG, are you sure you're 
> getting 17 and 18?
> 

  Absolutely right (bad bad typo, have to control my trembling fingers)
  It's 16/17.

  So that's ok ? No misconfiguration ? And that setserial tells
  me the port is 0x000 ? I thought the dts file which
  comes with the linkstation kernel describes the ports and IRQs
  but poking there didn't change anything. It seems like the kernel
  is ignoring the serial settings in the dts-file (which I do not
  realy understand) all together.


>> communication errors
>>
>> "to much work in IRQ 16"
> 
> And here you get IRQ 16, which indeed should be ttyS0. And ttyS0 is 
> connected to the power-management microcontroller (AVR). Wait, what 
> userspace are you running? Have you swapped ttyS0 and ttyS1 everywhere? in 
> /etc/inittab for example? Besides, if you are running any vendor provided 
> (or community) tools to handle the AVR - they use ttyS1 by default, as it 
> was under 2.4 ans under "traditional" 2.6, whereas the 2.6 mainline kernel 
> for kurobox/linkstation uses the traditional for these CPUs port 
> numbering. I think this is your problem. Some user-space programme(s) are 
> accessing wrong tty.

   I started with a debian distro
   http://www.kurobox.com/mwiki/index.php/Debian_sylver

   Hmm I tried my very best to eliminate this everywhere. Actually I
   resurrected the ARV00 device by creating a soft link to a ttySx
   with during bootup within the udev filesystem.

   <snip>
         if [ ! -e /dev/AVR00 ];then
          cat /proc/tty/driver/serial | grep 80004500 | grep -q 0:
            && AVR=/dev/ttyS0 || AVR=/dev/ttyS1
          echo "Making AVR00 link to "$AVR;
          ln -s $AVR /dev/AVR00
         fi;
   </snip>

Stole the trick from the avr_evtd startup script...

Thanks a 10^6 for the tips...

Oncaphillis


> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

