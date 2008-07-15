Return-Path: <linux-kernel-owner+w=401wt.eu-S1757174AbYGOWra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174AbYGOWra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbYGOWrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:47:11 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50778 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbYGOWrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:47:10 -0400
Message-ID: <487D28C6.9000309@garzik.org>
Date: Tue, 15 Jul 2008 18:46:30 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, david@lang.hm,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from	in-kernel,
 use it in more drivers.
References: <alpine.LFD.1.10.0807141903260.3017@woody.linux-foundation.org>	 <487C585C.2060002@garzik.org>	 <alpine.LFD.1.10.0807150803580.3017@woody.linux-foundation.org>	 <487CD7FE.9010209@garzik.org>	 <alpine.LFD.1.10.0807151008450.3017@woody.linux-foundation.org>	 <487CDEC0.3090004@garzik.org>	 <alpine.LFD.1.10.0807151041080.3017@woody.linux-foundation.org>	 <487CEA73.9000408@garzik.org>	 <alpine.LFD.1.10.0807151124510.3017@woody.linux-foundation.org>	 <487CF01E.6000208@garzik.org> <20080715185801.GH8185@mit.edu>	 <487CF70C.1030309@garzik.org>	 <alpine.LFD.1.10.0807151218460.3351@woody.linux-foundation.org>	 <487D1327.7090805@garzik.org>	 <alpine.LFD.1.10.0807151420550.2867@woody.linux-foundation.org>	 <487D1925.50008@garzik.org> <1216159959.26991.48.camel@shinybook.infradead.org>
In-Reply-To: <1216159959.26991.48.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Tue, 2008-07-15 at 17:39 -0400, Jeff Garzik wrote:
>> 'make modules_install && make install' will
>>         * install modules in /lib
>>         * install firmware in /lib      [2.6.27 only]
>>         * install kernel
>>         * update grub
>>         * rebuild initrd
>>
>> Do this, under both 2.6.26 and 2.6.27.
>>
>> 2.6.26 will put a working driver into initrd.
>>
>> 2.6.27 will put a dead driver into initrd (because no firmware got 
>> copied into initrd image).
> 
> I believe your claim is untrue. It uses the distribution's tool to
> create the initrd, doesn't it? And those tools _do_ handle the
> MODULE_FIRMWARE() tags and pull in appropriate firmware.

slackware's CURRENT mkinitrd and kernel-modules scripts appear to 
disprove your claims.  And yes, they use a modern kernel, 2.6.24.


> They've had to
> get that right for _years_ already.

You should not just /assume/ that everything is ok, simply because time 
passed since request_firmware() was added.  Or let impatience blind you 
to the breakage that will result from your change.

Further, there are several factors that clearly differentiate a driver 
that has been using request_firmware() for a while, and newly converting 
a large block of drivers en masse.

	Jeff


