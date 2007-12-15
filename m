Return-Path: <linux-kernel-owner+w=401wt.eu-S932078AbXLOCVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbXLOCVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 21:21:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbXLOCVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 21:21:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41239 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbXLOCVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 21:21:01 -0500
Message-ID: <476339D4.2090802@zytor.com>
Date: Fri, 14 Dec 2007 18:20:04 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "David P. Reed" <dpreed@reed.com>
CC: Avi Kivity <avi@qumranet.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Pavel Machek <pavel@ucw.cz>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
 on some AMD64x2 laptops, etc.
References: <466F0941.9060201@reed.com> <1181682498.8176.224.camel@chaos>	 <469578CD.3080609@reed.com>  <1184216528.12353.203.camel@chaos>	 <1184218962.12353.209.camel@chaos>  <46964352.7040301@reed.com>	 <1184253339.12353.223.camel@chaos>  <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <4762AA68.9030507@qumranet.com> <4763385E.9040106@reed.com>
In-Reply-To: <4763385E.9040106@reed.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David P. Reed wrote:
> 
> I believe (though no one seems to have confirming documentation from the 
> chipset or motherboard vendor) that port 80 is actually functional for 
> some unknown function on these machines.   (They do respond to "in" 
> instructions faster than a bus cycle abort does - more evidence).
> 

This is normal.  IN from port 0x80 is used by the DMA address map chip.

As far as I understand, there are other laptops with the same chipset 
which don't have this problem, so it's likely either a motherboard or 
firmware issue.  My guess is that they probably let debugging code out 
in the field (trap port 0x80 in SMM, and then try to output it on some 
debugging bus.)

	-hpa
