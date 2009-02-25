Return-Path: <linux-kernel-owner+w=401wt.eu-S1758880AbZBYTXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880AbZBYTXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 14:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756405AbZBYTXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 14:23:38 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:34580 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017AbZBYTXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 14:23:37 -0500
X-Greylist: delayed 337 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Feb 2009 14:23:36 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xPwqrCpcrSQv2Flt3eAciHkG3WIpj9YhXFZPc9SXSQDpckAjDHqXHFWlllR/JRzg+1
         REg8OXYEKG0KmoI2SQTynEa0nOm20glMxcJ/PwCs78qh7aNpY5ZF2jL8PZzCNAR9fKVB
         bQgIJuxPDNhUGMELA1mRfzQdrY7L7rKb4WhBM=
MIME-Version: 1.0
In-Reply-To: <1235410406.6216.69.camel@penberg-laptop>
References: <1235381712.6216.22.camel@penberg-laptop>
	 <alpine.DEB.1.10.0902231039580.7298@qirst.com>
	 <1235410406.6216.69.camel@penberg-laptop>
Date: Wed, 25 Feb 2009 20:17:57 +0100
Message-ID: <19f34abd0902251117h7a4a6e9ao34e972110d8b40a1@mail.gmail.com>
Subject: Re: [PATCH] kmemcheck: Disable SLUB and SLAB debugging when kmemcheck 
	is enabled
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/23 Pekka Enberg <penberg@cs.helsinki.fi>:
> On Mon, 2009-02-23 at 10:41 -0500, Christoph Lameter wrote:
>> On Mon, 23 Feb 2009, Pekka Enberg wrote:
>>
>> > Enabling kmemcheck in Kconfig is a painful experience. Lets make it a
>> > tad bit easier by inverting the dependencies to SLUB and SLAB debugging.
>> > As kmemcheck is more powerful than slab debugging, disable the latter
>> > functionality if an user enables kmemcheck.
>>
>> SLUB_DEBUG is fundamentally different from SLAB_DEBUG. It only includes
>> the code to be able to enable debugging at runtime. It does not enable
>> debugging.
>
> Yes, I know that but we can't really let the user enable both, slub
> debugging and kmemcheck debugging, at run-time. That's why I used
> SLUB_DEBUG here.

It is possible. Which is why it said SLUB_DEBUG_ON to begin with. This
is how it works:

If slub_debug=,xyz is specified on the command line, the SLUB
debugging will be used for the "xyz" cache, and kmemcheck will track
the rest (all non-slub-debugged caches). So if we only disable
SLUB_DEBUG_ON, then slub debugging and kmemcheck debugging can still
be mixed at boot-time, but kmemcheck will take precedence unless
slub_debug= is specified.

Can you rethink whether SLUB_DEBUG or SLUB_DEBUG_ON is the one we
really want to depend on !KMEMCHECK, and either submit a new patch or
convince me that this is sufficient?

Thanks!


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
