Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab0CLEpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 23:45:44 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:54860 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab0CLEpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 23:45:42 -0500
Subject: Re: [PATCH] firmware class: export nowait to userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Tomas Winkler <tomasw@gmail.com>,
       Greg KH <greg@kroah.com>, David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <ac3eb2511003112021o647a288dr453836bb94460af4@mail.gmail.com>
References: <1268347174.4142.11.camel@jlt3.sipsolutions.net>
	 <1268348199.4142.33.camel@jlt3.sipsolutions.net>
	 <ac3eb2511003112021o647a288dr453836bb94460af4@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Mar 2010 20:46:03 -0800
Message-ID: <1268369163.4828.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-12 at 05:21 +0100, Kay Sievers wrote:
> On Thu, Mar 11, 2010 at 23:56, Johannes Berg <johannes@sipsolutions.net> wrote:
> > When we use request_firmware_nowait(), userspace may
> > not want to answer negatively right away when for
> > example it is answering from an initrd only, but
> > with request_firmware() it has to in order to not
> > delay the kernel boot until the request times out.
> >
> > This allows userspace to differentiate between the
> > two in order to be able to reply negatively to async
> > requests only when all filesystems have been mounted
> > and have been checked for the requested firmware file.
> 
> The firmware_class already always exports a TIMEOUT= value, right? If
> this is the case, it should be set to 0, I guess.

Yes and no. It is exported, but typically it will be 60 seconds. And
even in this case it makes sense to eventually time out when userspace
is not responding.

> Sounds fine to have a flag like this, while "NOWAIT" is, I guess, a
> pretty bad name from the event perspective. This name might make sense
> for the called kernel function, but not so much for a firmware loader
> instruction.

Yeah, I can agree with that. How about "ASYNC" or so? It needs to
distinguish between "I'm going to wait for this please respond" and "I'm
not really waiting, please let me now when you can".

johannes

