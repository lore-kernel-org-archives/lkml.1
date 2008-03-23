Return-Path: <linux-kernel-owner+w=401wt.eu-S1759201AbYCWSqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201AbYCWSqk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 14:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754464AbYCWSqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 14:46:33 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:48059 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbYCWSqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 14:46:32 -0400
Date: Sun, 23 Mar 2008 19:46:30 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "John T." <j.thomast@yahoo.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: UTF-8 and Alt key in the console
In-Reply-To: <205509.99433.qm@web45710.mail.sp1.yahoo.com>
Message-ID: <alpine.LNX.1.00.0803231942380.3157@fbirervta.pbzchgretzou.qr>
References: <205509.99433.qm@web45710.mail.sp1.yahoo.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 2008-03-23 19:13, John T. wrote:
>> Hardly.  vim clearly can deal with the ESC-is-prefix issue anyway, since
>> otherwise it wouldn't be able to use arrow keys.
>
> There's always the "timeout" hack. It is allright with the
> arrow and function keys because the second character in these
> cases (`[' usually) is not a commonly typed vim command.
>[...]
>> The best probably would be to introduce an escape code, along the lines
>> of other escape codes in the terminal interfae.
>
> You're right.
>
> Many say Unix is also broken compared to Plan 9.. sometimes it's
> too late. The real fix for this issue seems like it'd be very
> hard to accomplish.

The idea of revamping the escape codes is not all that bad.

Thanks to terminfo, this should be easy. Change vt.c,
add corresponding terminfo entry and set TERM to something
that has not previously existed.

About the ESC key, I thought, would it suffice to replace its
current output of ^[ with ^[^[?
