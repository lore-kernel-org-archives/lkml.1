Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbXFKXEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbXFKXEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 19:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbXFKXER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 19:04:17 -0400
Received: from mailout05.sul.t-online.com ([194.25.134.82]:39078 "EHLO
	mailout05.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751545AbXFKXEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 19:04:16 -0400
Message-ID: <466DD4E1.4030305@t-online.de>
Date: Tue, 12 Jun 2007 01:04:01 +0200
From: Bernd Schmidt <bernds_cb1@t-online.de>
User-Agent: Thunderbird 2.0.0.0 (X11/20070519)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Matt Mackall <mpm@selenic.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, "Wu, Bryan" <Bryan.Wu@analog.com>,
       Greg Ungerer <gerg@snapgear.com>
Subject: Re: [PATCH, RFD]: Unbreak no-mmu mmap
References: <46695F6D.5050600@t-online.de> <20070609191010.GB11166@waste.org> <8bd0f97a0706111509s161c6287pdce612946194d87@mail.gmail.com>
In-Reply-To: <8bd0f97a0706111509s161c6287pdce612946194d87@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ID: Z62NjOZ-ZeucXVqeehFKwcu3HEWwFc7VJqr0vlEOGWBiT4lccyI80F
X-TOI-MSGID: f81c8c1a-a66a-4719-b7f9-91f4e122bc79
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On 6/9/07, Matt Mackall <mpm@selenic.com> wrote:
>> On Fri, Jun 08, 2007 at 03:53:49PM +0200, Bernd Schmidt wrote:
>> > 2. It is no longer possible to get blocks smaller than a page through
>> >    mmap.  This behaviour was used by simplemalloc, which is an insane
>> >    way of implementing malloc on nommu systems and hopefully not used
>> >    by anyone anymore.
>>
>> That's worrisome. Breaking existing apps/libraries seems like a bad
>> idea.
> 
> it isnt breaking anything ... simplemalloc() will continue to execute
> in newer kernels

While that's true, it'll have an even bigger memory overhead than it
already does (simplemalloc, by trapping into the kernel and creating
vm_area/vm_list structures for every malloc call, has huge overheads in
both time and space).
I've posted this as an RFD to get a feeling for whether we can change
behaviour here - I do expect that nommu embedded systems are less
constrained by backwards compatibility considerations, but I'd like to
hear from other embedded users whether this is a change they'd welcome.


Bernd
-- 
This footer brought to you by insane German lawmakers.
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 40368
Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif
