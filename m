Return-Path: <linux-kernel-owner+w=401wt.eu-S932373AbZJ0Uxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373AbZJ0Uxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 16:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932300AbZJ0Uxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 16:53:32 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:39593 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932353AbZJ0Uxa convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-ghaskins@novell.com;2:1>);
	Tue, 27 Oct 2009 16:53:30 -0400
Message-Id: <4AE7258D0200005A000576F6@sinclair.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 27 Oct 2009 14:53:33 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, <linux-kernel@vger.kernel.org>
Subject: Re: Zillions of warnings in -next
References: <20091027152530.75ca60e4@lxorguk.ukuu.org.uk>
In-Reply-To: <20091027152530.75ca60e4@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 10/27/2009 at 11:25 AM, in message
<20091027152530.75ca60e4@lxorguk.ukuu.org.uk>, Alan Cox
<alan@lxorguk.ukuu.org.uk> wrote: 
> I was thinking "what a lot of new warnings". Then I dug a little deeper
> and it seems that someone never bothered to try and build
> drivers/net/vbus-enet.c on a 32bit system.
> 
> So would you mind fixing the 27 new warnings introduced ?
> 
> Alan

I just did a 32-bit build and indeed reproduced the warnings.  However, the warnings
appear to be dubious as the code is properly (afaict) annotated with explicit casts, and
I believe they are doing what I intended.

Basically I have structures that are always 64 bit (so we can have a mixed-mode 32-bit
guest talk to a 64-bit hypervisor, for instance).  Therefore I am casting between native
and u64, but the compiler doesn't like this.  Does anyone have any suggestions on ways
to fix this so the compiler is happy?

For instance:

struct foo {
   u64 bar;
}

xmit_foo(void *ptr)
{
 struct foo f;

 f->bar = (u64)ptr; /* generates warning */
}

Kind Regards,
-Greg



