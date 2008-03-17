Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbYCQX0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbYCQX0B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 19:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbYCQXZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 19:25:54 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:54866 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbYCQXZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 19:25:53 -0400
Message-ID: <47DEFE3A.2030904@keyaccess.nl>
Date: Tue, 18 Mar 2008 00:26:50 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: "Lev A. Melnikovsky" <melnikovsky@mail.ru>,
       Alessandro Suardi <alessandro.suardi@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ehci-hcd affects hda speed
References: <alpine.LFD.1.00.0803050036210.31935@nev.ubzr> <alpine.LFD.1.00.0803160054360.23451@nev.ubzr> <47DC596A.4010800@keyaccess.nl> <200803171400.40045.david-b@pacbell.net> <47DEFD85.1050706@keyaccess.nl>
In-Reply-To: <47DEFD85.1050706@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18-03-08 00:23, Rene Herman wrote:

> On 17-03-08 22:00, David Brownell wrote:
> 
>>> On 15-03-08 23:46, Lev A. Melnikovsky wrote:
>>>
>>>> changing the bit 5 (EHCI sleep time select:  0=1us 1=10us)
>>>> of register 0x4B seems to resolve my own problem.
>>
>> Note that 10 usec is the value used in the EHCI spec.
>>
>> And yes, waiting only 1 usec between schedule scans is
>> absolutely certain to hammer on the PCI bus quite rudely,
>> preventing other devices from getting Real Work done.
>>
>> Could someone put together an EHCI patch to make sure
>> that bit is set on vt6212 parts?  For the VT8235 that
>> register seems to be marked (in an old document someone
>> forwarded to me) as "reserved, do not program"; so this
>> should be specific to vt6212 EHCI.  (PCI vendor 0x1106,
>> device 0x3104, revision 0x60 ... the revision being what
>> says "vt6212" vs "vt8235" or "vt8237" etc.
> 
> Just something like this? Completely untested as I've not the hardware 
> anymore. Googling for an old lspci, I had a revision 0x63, and Lev has a 
> revision 0x65. The VT6212(L) should be 0x60+ it seems.
> 
> The "CC:" should be a "Tested-by:" if that's actually the case.
> 
> But yes, as he also asked, should this be the fix at all?

And, as usual, I can not reach Lev as some mailer along the way is telling 
me his address is unroutable.

Rene.
