Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab0CLEWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 23:22:12 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41358 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab0CLEWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 23:22:11 -0500
MIME-Version: 1.0
In-Reply-To: <1268348199.4142.33.camel@jlt3.sipsolutions.net>
References: <1268347174.4142.11.camel@jlt3.sipsolutions.net> 
	<1268348199.4142.33.camel@jlt3.sipsolutions.net>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 12 Mar 2010 05:21:54 +0100
Message-ID: <ac3eb2511003112021o647a288dr453836bb94460af4@mail.gmail.com>
Subject: Re: [PATCH] firmware class: export nowait to userspace
To: Johannes Berg <johannes@sipsolutions.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Tomas Winkler <tomasw@gmail.com>,
       Greg KH <greg@kroah.com>, David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 23:56, Johannes Berg <johannes@sipsolutions.net> wrote:
> When we use request_firmware_nowait(), userspace may
> not want to answer negatively right away when for
> example it is answering from an initrd only, but
> with request_firmware() it has to in order to not
> delay the kernel boot until the request times out.
>
> This allows userspace to differentiate between the
> two in order to be able to reply negatively to async
> requests only when all filesystems have been mounted
> and have been checked for the requested firmware file.

The firmware_class already always exports a TIMEOUT= value, right? If
this is the case, it should be set to 0, I guess.

Sounds fine to have a flag like this, while "NOWAIT" is, I guess, a
pretty bad name from the event perspective. This name might make sense
for the called kernel function, but not so much for a firmware loader
instruction.

Thanks,
Kay
