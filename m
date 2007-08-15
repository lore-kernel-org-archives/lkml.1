Return-Path: <linux-kernel-owner+w=401wt.eu-S1760796AbXHOJcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760796AbXHOJcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 05:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbXHOJcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 05:32:14 -0400
Received: from orion2.pixelized.ch ([195.190.190.13]:56802 "EHLO
	mail.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbXHOJcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 05:32:13 -0400
Message-ID: <46C2C810.4000905@cateee.net>
Date: Wed, 15 Aug 2007 11:32:00 +0200
From: "Giacomo A. Catenazzi" <cate@cateee.net>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Jason Uhlenkott <jasonuhl@jasonuhl.org>,
       Arjan van de Ven <arjan@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: kfree(0) - ok?
References: <46C233CB.9000602@am.sony.com> <1187132149.2618.2.camel@laptopd505.fenrus.org> <20070814232107.GA4265@aurum.uhlenkott.net> <Pine.LNX.4.64.0708150928200.19270@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708150928200.19270@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Aug 14 2007 16:21, Jason Uhlenkott wrote:
>> On Tue, Aug 14, 2007 at 15:55:48 -0700, Arjan van de Ven wrote:
>>> NULL is not 0 though.
>> It is.  Its representation isn't guaranteed to be all-bits-zero,
> 
> C guarantees that.

Hmm. It depends on your interpretation of "representation".
On memory a null pointer can have some bit set.

No, see a very recent discussion on austin group list
(which list also few machines that don't have all 0-bits null pointer)

To clarify, from Rationale of C99, section 6.7.8 "Initialization":

: An implementation might conceivably have codes for floating zero
: and/or null pointer other than all bits zero. In such a case,
: the implementation must fill out an incomplete initializer with
: the various appropriate representations of zero; it may not just
: fill the area with zero bytes. As far as the committee knows,
: all machines treat all bits zero as a representation of
: floating-point zero. But, all bits zero might not be the
: canonical representation of zero.

Anyway, I think for kernel it is safe to assume all-zero bit
null pointer.

ciao
	cate
