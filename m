Return-Path: <linux-kernel-owner+w=401wt.eu-S1759966AbZGHJsC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966AbZGHJsC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 05:48:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758466AbZGHJry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 05:47:54 -0400
Received: from smtp-out.google.com ([216.239.33.17]:33580 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758094AbZGHJrx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 05:47:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=u3egtouJNU0jtWPFicL3DQ8RYiNgERIikObui8Wix46SivSOGwUS4eGnRJno8L/eT
	0fq2tdsxk/riZHMvNQSKg==
MIME-Version: 1.0
In-Reply-To: <20090708084439.GC20020@elf.ucw.cz>
References: <20090629114339.GA25552@elf.ucw.cz>
	 <20090702200824.GJ10957@kroah.com> <20090708084439.GC20020@elf.ucw.cz>
Date: Wed, 8 Jul 2009 02:47:46 -0700
Message-ID: <a55d774e0907080247x23a2f134p1ecdb079c158df5@mail.gmail.com>
Subject: Re: HTC Dream camera support for staging
From: Brian Swetland <swetland@google.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, malchev@google.com,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 8, 2009 at 1:44 AM, Pavel Machek<pavel@ucw.cz> wrote:
> On Thu 2009-07-02 13:08:24, Greg KH wrote:
>> On Mon, Jun 29, 2009 at 01:43:40PM +0200, Pavel Machek wrote:
>> >
>> > This patch adds driver for HTC Dream camera. I guess driver is
>> > slightly higher quality than usual for staging/ , but it is fairly big
>> > and I don't feel like doing all the cleanups myself. Also some parts
>> > can probably be removed, as they did not end up in shipping hardware..
>> >
>> > The driver is actually so big that I'll attach it gzipped, otherwise
>> > it would not pass maillist limits.
>> >
>> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
>> > Cc: Brian Swetland <swetland@google.com>
>>
>> Can you resubmit it with the original author descriptions?  It's not
>> fair to them to have it shown up as coming from you.
>
> Yes, done... and thanks.
>
> Brian... I'd like to submit qdsp5 and smd code, too. Who should be
> listed as their authors?

smd is pretty much my fault at this point, though Arve hacks on the
PM-related bits.

The latest incarnation of the rpcrouter is me, with a lot of the
original work by Iliyan, based heavily on the work Qualcomm did (thus
their copyright on it as well as Google's).

qdsp5 is Iliyan.

Might be worth breaking these into at least three pieces (smd,
rpcrouter, qdsp5)?

Are you highly opposed to having smd and rpcrouter under
arch/arm/mach-msm?  They're (for better or worse) pretty integral to
the core operation of the platform (suspend/resume and a lot of other
core SoC functions require coordination with the modem core).

The qdsp5 stuff could exist elsewhere easily (though I'm not sure
where the logical place is), and stuff on top of it like the v4l2
camera stuff has obvious homes in the usual driver hierarchy.

Brian
