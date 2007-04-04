Return-Path: <linux-kernel-owner+w=401wt.eu-S966288AbXDDCZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966288AbXDDCZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 22:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966289AbXDDCZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 22:25:54 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:42612 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S966288AbXDDCZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 22:25:54 -0400
Date: Tue, 3 Apr 2007 18:57:22 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Valdis.Kletnieks@vt.edu
cc: Brad Boyer <flar@allandria.com>, David Woodhouse <dwmw2@infradead.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
In-Reply-To: <7641.1175652638@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.63.0704031853020.21680@qynat.qvtvafvgr.pbz>
References: <1175610345.2665.15.camel@shinybook.infradead.org>
 <17938.57292.870224.132415@cargo.ozlabs.ibm.com>
 <1175642916.10567.24.camel@shinybook.infradead.org> <20070403212928.GA12951@cynthia.pants.nu>
 <1175644642.10567.31.camel@shinybook.infradead.org> <20070403221002.GA13210@cynthia.pants.nu>
 <1175648051.10567.61.camel@shinybook.infradead.org>           
 <20070403230908.GA13471@cynthia.pants.nu> <7641.1175652638@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007, Valdis.Kletnieks@vt.edu wrote:

> On Tue, 03 Apr 2007 16:09:08 PDT, Brad Boyer said:
>
>> an abstraction of "serial port" as far as the user is concerned. On
>> Solaris, I can say "/dev/term/a" and know that I will get the first
>> serial port if it is available without needing to care if it is the
>> zs, se or asy driver talking to the hardware.
>
> This is fine if you're trying to boot and find your system console.
>
> It blows complete chunks if the port you're trying to find is the
> first port on the special serial card that supports speeds above 115kbaud
> because we have a real-time constraint, and even at 115k you fall short
> on the timing budget (actual real-life issue we hit on an SGI running IRIX
> a number of years ago. Blowing the budget often resulted in a 3,000 pound
> motion base to turn into a 3,000 pound jackhammer:
> http://www.sv.vt.edu/future/cave/resprj/crane/crane_thor/2001FebReport.html
> http://www.moog.com/Media/1/6D2000E500-395_1102.pdf
>

but when you are looking for this port, you would lookup which port it is, make 
something active on that port (if only a getty), and then confirm the port by 
plugging into it and testing it.

in other words, if you have a special constraint you will have to pay attention 
to the hardware to make sure it meets those requriements.

this is no different then the fact that many motherboards contain a 100Mb 
ethernet port as well as a pair of 1Gb ethernet ports. if you need speeds above 
100Mb you better make sure your useing the right port, but we don't name network 
ports based on the type of card.

David Lang

