Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbYJOL0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbYJOL0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 07:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbYJOL0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 07:26:35 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:26055 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751239AbYJOL0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 07:26:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=lyG3JceLmKGp1UV+Ajnm28bmi8fZwhs2nJZNF3kimk8kiYT9neT5sr/8HiKwbnYnGIypkftAG9K3SKK1eqPxdNDCDxGfdgun1y9AcD+BPccsV4jC5WezIp/ldKDsaAypza1q2Kc0JRTncBJMNkO9l/FMjuMp6d2xfgBt3A034nA=  ;
X-YMail-OSG: ZVnoxsMVM1lb6tUazxqEyWbZEs31bk.Y8qFSeCNKHrkkhmJGk05ABFM6Q9AUF_CHdNy2CSS9QkXPDyLxbuTpD2fcff4a9ZsHVg7OpA_I7tTHUD9KmRrnLH9xi2sXsOf_tSlzCwyZA4K61I788GAi4hAF1j8aHR5k1VJnzvnpADxEd_Yu5U9aICxJaxHw
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Kaz Kylheku" <kkylheku@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-mm@kvack.org
Subject: Re: GPL question: using large contiguous memory in proprietary driver.
Date: Wed, 15 Oct 2008 22:26:00 +1100
User-Agent: KMail/1.9.5
Cc: "Chris Friesen" <cfriesen@nortel.com>, linux-kernel@vger.kernel.org
References: <3f43f78b0810141456r159d71e7h9763e50e7dbc0c51@mail.gmail.com> <48F5193B.1010601@nortel.com> <3f43f78b0810141639w4ec50a08tdc847b16ebcea5be@mail.gmail.com>
In-Reply-To: <3f43f78b0810141639w4ec50a08tdc847b16ebcea5be@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810152226.00668.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 October 2008 10:39, Kaz Kylheku wrote:
> On Tue, Oct 14, 2008 at 3:12 PM, Chris Friesen <cfriesen@nortel.com> wrote:
> > Kaz Kylheku wrote:
> >> I have the following question. Suppose that some proprietary driver
> >> (otherwise completely clean, based only on non-GPL symbols)
> >
> > The fact that it's not using GPL symbols does not actually mean that the
> > driver is not a derivative work of the kernel (and thus subject to the
> > GPL).
>
> One more thing. Here is another question.

I don't know if there are any lawyers on this list, and definitely you
shouldn't take this kind of advice from answers here.


> Suppose that this proprietary driver can be moved entirely into user
> space. It still needs the contiguous buffer, but it can
> map it using mmap, given the address.

The kernel carries a license that states:

'NOTE! This copyright does *not* cover user programs that use kernel
 services by normal system calls - this is merely considered normal use
 of the kernel, and does *not* fall under the heading of "derived work".'

Which could be relevant.


> Can this proprietary user-space application read the address
> of this buffer from a custom /proc entry?
>
> Or does this dependency make it a derived work of the kernel?

I would be careful if you were to explicitly modify the kernel you
distribute with the driver in order to allow your driver to live
in userspace. No idea whether that is safe.

However, we do have this pagemap proc API existing in the kernel
which is a kernel service that can be used with a normal system
call. It returns the page frame number that a given virtual address
is mapped to. (God knows WTF that is supposed to be a remotely good
idea for the kernel to export, but there you have it.)

Whether that helps you or allows you to comply with your obligations,
I don't know.

Or, as an alternative, why not instead run the gauntlet with your
other licensor and tell them their license isn't acceptable because
your product contains code with incompatible restrictions?!
