Return-Path: <linux-kernel-owner+w=401wt.eu-S1759552AbZBEAY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552AbZBEAY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 19:24:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbZBEAYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 19:24:18 -0500
Received: from rex.securecomputing.com ([203.24.151.4]:43111 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752349AbZBEAYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 19:24:17 -0500
Message-ID: <498A31AC.7090902@snapgear.com>
Date: Thu, 05 Feb 2009 10:24:12 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: uClinux development list <uclinux-dev@uclinux.org>
CC: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       linux-m68k@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [uClinux-dev] Re: Fix support for console port other than ttyS0
 on	mcf.c
References: <20090204201518.GH26064@csclub.uwaterloo.ca>	<20090204202009.GI26064@csclub.uwaterloo.ca> <Pine.LNX.4.64.0902042200340.25136@anakin>
In-Reply-To: <Pine.LNX.4.64.0902042200340.25136@anakin>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Geert Uytterhoeven wrote:
> On Wed, 4 Feb 2009, Lennart Sorensen wrote:
>> Perhaps CCing linux-m68k@lists.linux-m68k.org would be a good idea.
> 
> Thanks, but this is a uClinux driver.

I have commited this to the m68knommu git tree on kernel.org.

Thanks
Greg



>> On Wed, Feb 04, 2009 at 03:15:18PM -0500, Lennart Sorensen wrote:
>>> Due to a case of backwards logic, mfc.c always makes the console port be
>>> ttyS0 even when you ask for another port.
>>>
>>> This patch fixes this issue.
>>>
>>> Only when the requested port is NOT in the range 0 to MAXPORTS-1 do we
>>> force it to be treated as if port 0 was requested.  Forcing the port to
>>> 0 when it is in fact in the range 0 to MAXPORTS is not helpful.
>>>
>>> Tested with working console on ttyS2 on a 5271evb.
>>>
>>> Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>
>>>
>>> diff --git a/drivers/serial/mcf.c b/drivers/serial/mcf.c
>>> index 56841fe..0eefb07 100644
>>> --- a/drivers/serial/mcf.c
>>> +++ b/drivers/serial/mcf.c
>>> @@ -513,7 +513,7 @@ static int __init mcf_console_setup(struct console *co, char *options)
>>>         int parity = 'n';
>>>         int flow = 'n';
>>>
>>> -       if ((co->index >= 0) && (co->index <= MCF_MAXPORTS))
>>> +       if ((co->index < 0) || (co->index >= MCF_MAXPORTS))
>>>                 co->index = 0;
>>>         port = &mcf_ports[co->index].port;
>>>         if (port->membase == 0)
> 
> Gr{oetje,eeting}s,
> 
> 						Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
> 							    -- Linus Torvalds
> _______________________________________________
> uClinux-dev mailing list
> uClinux-dev@uclinux.org
> http://mailman.uclinux.org/mailman/listinfo/uclinux-dev
> This message was resent by uclinux-dev@uclinux.org
> To unsubscribe see:
> http://mailman.uclinux.org/mailman/options/uclinux-dev
> 

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear, a McAfee Company                  PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
