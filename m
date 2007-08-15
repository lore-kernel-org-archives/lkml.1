Return-Path: <linux-kernel-owner+w=401wt.eu-S1764281AbXHOQJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764281AbXHOQJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 12:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757167AbXHOQJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 12:09:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58353 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763408AbXHOQJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 12:09:03 -0400
Message-ID: <46C32366.2040900@zytor.com>
Date: Wed, 15 Aug 2007 09:01:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Rene Herman <rene.herman@gmail.com>,
       Jason Uhlenkott <jasonuhl@jasonuhl.org>,
       Arjan van de Ven <arjan@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: kfree(0) - ok?
References: <46C233CB.9000602@am.sony.com> <1187132149.2618.2.camel@laptopd505.fenrus.org> <20070814232107.GA4265@aurum.uhlenkott.net> <Pine.LNX.4.64.0708150928200.19270@fbirervta.pbzchgretzou.qr> <46C2BB60.6010909@gmail.com> <Pine.LNX.4.64.0708151113410.19270@fbirervta.pbzchgretzou.qr> <46C2CE42.4010303@gmail.com> <Pine.LNX.4.64.0708151217120.5639@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708151217120.5639@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> 0 is all-bits-zero.
> NULL is 0. ("It is.", above)
> 
> Transitively, this would make NULL all-bits-zero.
> I might have missed something, though, perhaps that the cast to void* makes it
> intransitive.

It does -- a cast from integer to pointer isn't required to be a bitwise
noop.  Machines on which NULL isn't bitwise zero do exist, and the C
standard allows them.  What is almost certainly more common than "all
bits zero is not a NULL pointer" is "any NULL pointer is not necessarily
all bits zero"; there are quite a few machines on which there are
nonzero bitpatterns that are still valid NULL pointers, but an all-zero
memset() will still produce NULL pointers.

However, the particular supersets of the C standard that gcc provides
and which the kernel are written in (the latter being a proper subset of
the former) does not.

	-hpa
