Return-Path: <linux-kernel-owner+w=401wt.eu-S1762488AbXLTXxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762488AbXLTXxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 18:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbXLTXxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 18:53:17 -0500
Received: from smtp.ono.com ([62.42.230.12]:50603 "EHLO resmaa04.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754254AbXLTXxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 18:53:16 -0500
Date: Fri, 21 Dec 2007 00:53:03 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: "Linux kernel" <linux-kernel@vger.kernel.org>
Subject: Re: Trying to convert old modules to newer kernels
Message-ID: <20071221005303.771032f3@werewolf>
In-Reply-To: <Pine.LNX.4.61.0712201757410.9907@chaos.analogic.com>
References: <Pine.LNX.4.61.0712191503370.4688@chaos.analogic.com>
	<20071219202323.GH2310@csclub.uwaterloo.ca>
	<Pine.LNX.4.61.0712191555150.4514@chaos.analogic.com>
	<20071220150255.GE2308@csclub.uwaterloo.ca>
	<Pine.LNX.4.61.0712201107300.8261@chaos.analogic.com>
	<20071220182815.GA5438@uranus.ravnborg.org>
	<Pine.LNX.4.61.0712201623500.9531@chaos.analogic.com>
	<20071220220547.GA5641@uranus.ravnborg.org>
	<Pine.LNX.4.61.0712201757410.9907@chaos.analogic.com>
X-Mailer: Claws Mail 3.2.0cvs10 (GTK+ 2.12.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007 18:05:48 -0500, "linux-os (Dick Johnson)" <linux-os@analogic.com> wrote:

> 
> On Thu, 20 Dec 2007, Sam Ravnborg wrote:
> 
> > On Thu, Dec 20, 2007 at 04:27:37PM -0500, linux-os (Dick Johnson) wrote:
> >>
> >> On Thu, 20 Dec 2007, Sam Ravnborg wrote:
> >>
> >>>>
> >>>> It never gets to the printk(). You were right about the
> >>>> compilation. Somebody changed the kernel to compile with
> >>>> parameter passing in REGISTERS! This means that EVERYTHING
> >>>> needs to be compiled the same way, 'C' calling conventions
> >>>> were not good enough!
> >>>
> >>> How did you build the module. It reads like you failed to use
> >>> kbuild to build your module which is why you did not pass
> >>> correct options to gcc - correct?
> >>>
> >>> If you did not use kbuild - why not?
> >>> Is there anything missing you need?
> >>>
> >>
> >> I need to get rid of -mregparm=3 on gcc's command line. It
> >> is completely incompatible with the standard calling conventions
> >> used in all our assembly-language files in our drivers. We make
> >> very high-speed number-crunching drivers that munge high-speed
> >> data into images. We need to do that in assembly as we have
> >> always done.
> 

Just for curiosity... yep, I understand now you have everything written
in assembler, but why not consider start writing it in C and stop
doing the compiler work (such as pipelining, out of order reordering,
loop unrolling for specific processor, and so on...)

That's what everyone taught me, nowadays you won't be better than the
compiler in anything longer than three lines...

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux 2.6.23-jam05 (gcc 4.2.2 20071128 (4.2.2-2mdv2008.1)) SMP PREEMPT
