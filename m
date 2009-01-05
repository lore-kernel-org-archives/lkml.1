Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbZAEPO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbZAEPO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 10:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751066AbZAEPOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 10:14:17 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:49336 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbZAEPOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 10:14:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=e6A2CO7CoQEOuqwTAgodt4RvOfJGH+fyB8AYCv32vg81FYiIeZ8VdqEMekcGnpkCpr
         g8+EPDuHuixQMsxaCmUTYnZ7KfhKE5a9Px892PPklTgUtXW93SatTTajZA+PBouan1q6
         O+CrIWTULLCUZ2nBut55EqRDUF5ioYLcrWV1Q=
Message-ID: <496223C4.20307@gmail.com>
Date: Mon, 05 Jan 2009 16:14:12 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>, Johannes Weiner <hannes@cmpxchg.org>,
       Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       david@lang.hm, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: early exception error
References: <20081231195005.GT496@one.firstfloor.org> <alpine.DEB.1.10.0812311257060.18334@asgard.lang.hm> <20090101041727.GW496@one.firstfloor.org> <alpine.DEB.1.10.0812312212460.15026@asgard.lang.hm> <alpine.DEB.1.10.0901021014030.21408@asgard.lang.hm> <20090102172426.GB5372@localhost> <495E7FAD.6020305@shaw.ca> <20090105092619.GA3699@cmpxchg.org> <20090105130836.GN496@one.firstfloor.org> <49621E6E.2010809@gmail.com> <20090105150150.GF7645@localhost>
In-Reply-To: <20090105150150.GF7645@localhost>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2009 04:01 PM, Cyrill Gorcunov wrote:
> [Jiri Slaby - Mon, Jan 05, 2009 at 03:51:26PM +0100]
> | On 01/05/2009 02:08 PM, Andi Kleen wrote:
> | > +#define EARLY_BUG_ON(x) do { if (unlikely(!(x))) EARLY_BUG(); } while (0)
> | 
> | I think unintentionally inverted logic.
> 
> just second ! is missed :)

None is needed, two '!' are added in the macro itself while it passes the
parameter to the builtin.

> | 
> | > +#define EARLY_BUG_ON(x) do {} while(0)
> | 
> | Shouldn't be x referenced here?
> |
> 
> but for what?

I know, core devs are sane, but e.g. for reasons such as

{'a' is used here already}
EARLY_BUG_ON(!(a = readl(...)))
{use 'a' again}

to stay on the safe side.
