Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbZGOKK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbZGOKK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 06:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbZGOKK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 06:10:26 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:50458 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbZGOKK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 06:10:26 -0400
Message-ID: <4A5DA96F.8000900@monstr.eu>
Date: Wed, 15 Jul 2009 12:03:27 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>, Arnd Bergmann <arnd@arndb.de>,
       monstr@monstr.eu, Linux Kernel list <linux-kernel@vger.kernel.org>,
       LTP <ltp-list@lists.sourceforge.net>
Subject: Re: access_ok macor
References: <4A5C8068.6020203@monstr.eu> <200907141843.05629.arnd@arndb.de> <4A5CB8B4.7050108@monstr.eu> <200907141913.21240.arnd@arndb.de> <20090715092113.GA1863@linux-sh.org>
In-Reply-To: <20090715092113.GA1863@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> On Tue, Jul 14, 2009 at 07:13:20PM +0200, Arnd Bergmann wrote:
>> On Tuesday 14 July 2009, Michal Simek wrote:
>>> when the code tried to read/write from unaligned address (and in cpu
>>> is turn on unaligned exception) then is caused unaligned exception
>>> and asm code assemble/return value which is on that unaligned
>>> address. (Assemble it that read/write every byte separately). That
>>> will be harder to prevent all this cases because unaligned exception
>>> is in generic code.  What do you mean add __range_ok? Range checking
>>> is ok. The problem is when in case get_user kernel try to load
>>> unaligned addr - unaligned exception is perform and try to load that
>>> value separately.  If that page is not there, page fault handler is
>>> called and not find it, it is performed search from exception table
>>> and that address is not there of course - because address in pc is
>>> generic unaligned code. I think that handling this needs more code.
>>> Maybe if the address with from unaligned exception handler (there are
>>> some address which can caused it) and find out which aligned address
>>> is there and find out proper fixup for it.  I think that this could
>>> work.
>>>
>>> What do you think?
>> I think the key point is that the kernel should never try an unaligned
>> access. Other architectures already rely on this, so you can too.
> 
> No, other architectures used to rely on this, until it was no longer
> possible to do so. See for example, nfs. Unaligned accesses by the kernel
> must be handled by the architecture, unaligned accesses by userspace can
> be optionally fixed up.

Can you please look at John's email in this thread. How does SH handle this case?
I mean when for get/put user address is added unaligned address. How does your kernel handle it?

Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
