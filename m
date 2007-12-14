Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbXLNSER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbXLNSER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 13:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbXLNSEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 13:04:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44679 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbXLNSEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 13:04:05 -0500
Message-ID: <4762C551.5070003@zytor.com>
Date: Fri, 14 Dec 2007 10:02:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
 on some AMD64x2 laptops, etc.
References: <466F0941.9060201@reed.com> <1181682498.8176.224.camel@chaos> <469578CD.3080609@reed.com> <1184216528.12353.203.camel@chaos> <1184218962.12353.209.camel@chaos> <46964352.7040301@reed.com> <1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <20071214131502.GA14359@elte.hu>
In-Reply-To: <20071214131502.GA14359@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> wow, cool fix! (I remember that there were other systems as well that 
> are affected by port 0x80 muckery - i thought we had removed port 0x80 
> accesses long ago.)
> 
> how about the simpler fix below, as a first-level approach? We can then 
> remove the _p in/out sequences after this.
> 

I believe this will suffer from the issue that was raised: this will use 
udelay() long before loop calibration (and no, we can't just "be 
conservative" since there is no "conservative" value we can use.)

Worse, I suspect that at least the PIT, which may need to be used for 
udelay calibration, is one of the devices that may be affected.  I have 
seen the Verilog for a contemporary chipset, and it can only access the 
PIT once per microsecond -- this actually has to do with the definition 
of the PIT; some of the PIT operations are ill-defined if allowed at a 
higher frequency than the PIT clock.

	-hpa
