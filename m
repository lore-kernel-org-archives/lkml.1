Return-Path: <linux-kernel-owner+w=401wt.eu-S1753444AbYBRTz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbYBRTz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 14:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726AbYBRTzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 14:55:17 -0500
Received: from mail.nutech.com ([204.10.18.136]:4804 "EHLO mail.nutech.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085AbYBRTzP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 14:55:15 -0500
X-Greylist: delayed 2046 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Feb 2008 14:55:15 EST
From: sean mathews <mathewss@nutech.com>
Organization: Nu Tech Software
To: linux-kernel@vger.kernel.org, zarniwhoop@ntlworld.com
Subject: RE: init wont start on VIA EPIA 5000 500mhz board and randomely wont start on VIA EPIA MII 10000
Date: Mon, 18 Feb 2008 11:20:54 -0800
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802181120.55117.mathewss@nutech.com>
X-Declude-Spoolname: Dda9701ce00000a0a.smd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ken thanks for your insight. 

 You were correct that I was chasing multiple problems.

I still ended up crashing on boot after dealing with the processor issue. 

As it turns out a bug in bash 3.2 was the cause. As bash initializes before 
loading any script it calls a built in version of getcwd() that has a memcpy()
that reads out of bounds and may read across the stack and touch kernel
memory resulting in a fault. In my case patch bash32-11 triggered the bug
as this patch causes my build to force the use of this version of getcwd() 
and not the one built into libc.

The handling of kernel memory faults for process id 1 needs some work imho. 

As process ID 1 is not kernel or user some special conditions have been 
made in the kernel to deal with situations like this. The case of a SEGFAULT
into kernel memory for process ID 1 is not handled so you end up with an
infinite loop in the kernel trying to deal with the fault and the boot process
hangs with no visual indication as to what is wrong.

 Regards
  Sean Mathews

struct SoftwareProfessional {
   double salary;
   long   lunches;
   float  jobs;
   char   unstable;
   void   work;
   short  tempers;
};

On Jan 5, 7:30 pm, Ken Moffat <zarniwh...@ntlworld.com> wrote:
> 
>  As always, this is intended to be helpful, but treat it with a
> grain of salt, I could well be talking out of a different orifice
> than my mouth.  My last experience with aviaprocessor was a 1.2GHz
> beastie which certainly understood all i686 instructions, but
> managed to make snails look fast, and wasn't as power-frugal as
> expected, so I might be prejudiced.
> 
>  If you think your own toolchain is compiled for i586, you could try
> downloading one of the distros which definitely is built for i586 or
> i486 - if that works, it's a userspace compile problem.  Or, perhaps,
> the kernel actually needs to be built for i486 - I doubt that, but I
> don't have the hardware.
> 
> Ken
> --
> das eine Mal als Tragödie, das andere Mal als Farce
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majord...@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

