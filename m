Return-Path: <linux-kernel-owner+w=401wt.eu-S1753736AbYHTG03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbYHTG03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 02:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbYHTG0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 02:26:21 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:43063 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbYHTG0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 02:26:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=g/Ml/fPseC5xGV9lGHpMq0/Q4AyXIOCA2gWIqj2JdudDAULzcxktdf9o81GcYHQ27d
         YVrJDNhUPVGfHulEiUhvZr2pNG9BuSbGsbBKk69Q/8WKsOyUwVw5IDCPNxTve4AoyeDH
         rg2+eqYwShQHQ+JsdlZCNiUJGebuNL3ik/8o4=
Message-ID: <19f34abd0808192326jc10e758m99e76bbd5714c5b8@mail.gmail.com>
Date: Wed, 20 Aug 2008 08:26:19 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: latest -git: WARNING: at arch/x86/kernel/ipi.c:123 send_IPI_mask_bitmask+0xc3/0xe0()
Cc: "the arch/x86 maintainers" <x86@kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080820013930.GN9807@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0808191251x4eb61c50n13ecf7c90f0f3d9f@mail.gmail.com>
	 <20080820013930.GN9807@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 3:39 AM, Andi Kleen <andi@firstfloor.org> wrote:
> On Tue, Aug 19, 2008 at 09:51:44PM +0200, Vegard Nossum wrote:
>> Hi,
>>
>> With latest -git (1fca25427482387689fa27594c992a961d98768f), I got
>> this on reading from /dev/cpu/*/* while hot-unplugging cpu1.
>
> It's generally known the oprofile doesn't support CPU hotplug well.
> Someone needs to make a project out of fixing it properly. Right now
> it's just a "don't do that when it hurts"

Hm. What you say is true, but this one in particular has nothing to do
with oprofile! It has something to do with reading /dev/cpu/*/msr
while hot-unplugging cpu1:

 [<c011733e>] msr_read+0x6e/0xa0
 [<c01a87b4>] vfs_read+0x94/0x130

I wasn't using oprofile when this happened. So I think it should also
be considered a separate issue. Though yes -- CPU hotplug in general
tends to break a lot of things.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
