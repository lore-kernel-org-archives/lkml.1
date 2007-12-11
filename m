Return-Path: <linux-kernel-owner+w=401wt.eu-S1754291AbXLKBwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbXLKBwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 20:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbXLKBwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 20:52:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60522 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbXLKBwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 20:52:14 -0500
Message-ID: <475DED16.8020103@zytor.com>
Date: Mon, 10 Dec 2007 17:51:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: David Newall <david@davidnewall.com>
CC: Krzysztof Halasa <khc@pm.waw.pl>, Rene Herman <rene.herman@keyaccess.nl>,
       Pavel Machek <pavel@ucw.cz>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com> <p733auekcly.fsf@bingen.suse.de>	<20071207160439.71b7f46a@the-village.bc.nu>	<20071209125458.GB4381@ucw.cz>	<20071209165908.GA15910@one.firstfloor.org>	<20071209212513.GC24284@elf.ucw.cz> <475CBDD7.5050602@keyaccess.nl> <m3bq8y23de.fsf@maximus.localdomain> <475DE37F.20706@davidnewall.com> <475DE6F4.80702@zytor.com> <475DEB23.1000304@davidnewall.com>
In-Reply-To: <475DEB23.1000304@davidnewall.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall wrote:
> 
> Exactly.  You think it's 2us, but the documentation doesn't say.  The _p 
> functions are generic inasmuch as they provide an unspecified delay.  
> Drivers which work across platforms, and which use _p, therefore have 
> different delays on different platforms.  Should the length of the delay 
> be unimportant?  I wouldn't have thought so.  If it is important, does 
> that mean that such drivers are buggy on some platforms?
> 

That the _p delay is different across platforms is actually to be 
expected, since it pretty much amounts to a platform delay.  And yes, if 
it is used as a specific walltime delay that has nothing to do with the 
bus architecture of the system then I would classify that as a driver bug.

	-hpa
