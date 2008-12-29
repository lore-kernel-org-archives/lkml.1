Return-Path: <linux-kernel-owner+w=401wt.eu-S1753642AbYL2Ufy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbYL2Ufy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 15:35:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbYL2Uee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 15:34:34 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:48194 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752680AbYL2Uea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 15:34:30 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=SLALy5fqj+g0Ty3VTWGhEYFBuqN3LKEMA8QtmpL80lJ8DaZzw8ObKDoeYyYoeYrMGxTM339STljDfksbjo8xn4X9X8ji+eA8xtrAEYptgR4P9ZwilaGSpzIt1DK8+V0LxLUIz1CpEmPiHoBYo9yI4KXlK2OJVbEaYk8jn32YZrY=  ;
X-YMail-OSG: 0XRAGusVM1klodw3Ytw3WwXmahUVAmfEkZLGAsj9kHsvxEQ9T8kVkaNk_aLdwOuGVo2isRhihOtMuMk2Vpiq9eOcawSIQZknZ6zbHo61lV_M0a.Azs57j26ywLLjLg3zU9es2.ah554cCyWtJEfKHQA6
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add support for batch set of pins
Date: Mon, 29 Dec 2008 12:32:08 -0800
User-Agent: KMail/1.9.10
Cc: "Ben Nizette" <bn@niasdigital.com>,
       "Robin Getz" <rgetz@blackfin.uclinux.org>,
       "Eric Miao" <eric.y.miao@gmail.com>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Eric Miao" <eric.miao@marvell.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Philipp Zabel" <philipp.zabel@gmail.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Ben Gardner" <bgardner@wabtec.com>, "Greg KH" <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com> <1230501634.16910.57.camel@linux-51e8.site> <45a44e480812281628j214a9efvd19e4647fe30582c@mail.gmail.com>
In-Reply-To: <45a44e480812281628j214a9efvd19e4647fe30582c@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812291232.09174.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 December 2008, Jaya Kumar wrote:
> I'd like to get the start/length approach out there and in-play to
> find out if other people want to use it and how they end up using it.

As an *implementation* constraint, I might agree ... so
long as it's easily changed later.

As an *interface* constraint, I don't ... interfaces are
rarely easy to change.

However, in terms of implementation, most gpio chips have
primitives that work in terms of bitmasks rather than any
kind of start/length primitive.  Example:

 - To set bits in "u32 mask":
	iowrite32(mask, bank_base + SET_REG)
 - To clear bits in "u32 mask"
	iowrite32(mask, bank_base + CLR_REG)
 - To read bits in "u32 mask",
	return mask & ioread32(bank_base + VALUE_REG)

In short, start/length looks most like a policy, of the
"keep them out of interfaces!" flavor, than something
appropriate for an interface.  As noted above, gpio_chip
interfaces would more naturally use masks.

- Dave
