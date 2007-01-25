Return-Path: <linux-kernel-owner+w=401wt.eu-S965082AbXAYB15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965082AbXAYB15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 20:27:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965087AbXAYB15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 20:27:57 -0500
Received: from smtp109.sbc.mail.re2.yahoo.com ([68.142.229.96]:22709 "HELO
	smtp109.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965076AbXAYB14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 20:27:56 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Jan 2007 20:27:55 EST
X-YMail-OSG: oFOGhjwVM1lk4hHSStit.C7O0QawBqv3kSBhOBbZR0ycnfM6.kdXihocVbfU7FAW9Zjgrw18cS12ujMhfGcuabd9arBZHCOEijgZxu6XUHeZAJXiigy7EcVc9SZrK6UIms7r3MDG0pQA9P4-
Message-ID: <45B80610.5010804@rcn.com>
Date: Wed, 24 Jan 2007 19:21:20 -0600
From: Bill Cizek <cizek@rcn.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.20-rc5: cp 18gb 18gb.2 = OOM killer, reproducible just like
 2.16.19.2
References: <Pine.LNX.4.64.0701211424170.2552@p34.internal.lan> <20070122115703.97ed54f3.akpm@osdl.org> <Pine.LNX.4.64.0701241909120.2930@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0701241909120.2930@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> On Mon, 22 Jan 2007, Andrew Morton wrote:
>   
>>> On Sun, 21 Jan 2007 14:27:34 -0500 (EST) Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>>> Why does copying an 18GB on a 74GB raptor raid1 cause the kernel to invoke 
>>> the OOM killer and kill all of my processes?
>>>       
> Running with PREEMPT OFF lets me copy the file!!  The machine LAGS 
> occasionally every 5-30-60 seconds or so VERY BADLY, talking 5-10 seconds 
> of lag, but hey, it does not crash!! I will boot the older kernel with 
> preempt on and see if I can get you that information you requested.
>   
Justin,

According to your kernel_ring_buffer.txt (attached to another email), 
you are using "anticipatory" as your io scheduler:
   289  Jan 24 18:35:25 p34 kernel: [    0.142130] io scheduler noop 
registered
   290  Jan 24 18:35:25 p34 kernel: [    0.142194] io scheduler 
anticipatory registered (default)

I had a problem with this scheduler where my system would occasionally 
lockup during heavy I/O.  Sometimes it would fix itself, sometimes I had 
to reboot.  I changed to the "CFQ" io scheduler and my system has worked 
fine since then.

CFQ has to be built into the kernel (under BlockLayer/IOSchedulers).  It 
can be selected as default or you can set it during runtime:

echo cfq > /sys/block/<disk>/queue/scheduler
...

Hope this helps,
Bill
