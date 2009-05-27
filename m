Return-Path: <linux-kernel-owner+w=401wt.eu-S932409AbZE0SFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbZE0SFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759943AbZE0SF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:05:27 -0400
Received: from mail-px0-f123.google.com ([209.85.216.123]:60219 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759427AbZE0SF0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:05:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wFMVxmd0dQ8nCISsUUDnVKRbzJUNXgnWFI9RFNpAdFsTmowQwdom+bdJuHYktmy+Vk
         +V6qp/VkXWCjzsS9IYZ9AETvvkIxfXBT0sHA5m00iFYnxK9aO7eODba2Fo/UdT233OZG
         gMafgFJMU0RUksU6V7uwSjaLVTNe+uRaS3WGg=
MIME-Version: 1.0
In-Reply-To: <20090409142553.GA3330@emlix.com>
References: <E1LfGwO-0007Kq-6c@mailer.emlix.com>
	 <20090310073350.GH10393@linux-sh.org>
	 <20090402135343.d18d17a5.akpm@linux-foundation.org>
	 <20090409142553.GA3330@emlix.com>
Date: Wed, 27 May 2009 14:05:26 -0400
Message-ID: <8bd0f97a0905271105r7a91e2aby7d1cdfe1cc796bbf@mail.gmail.com>
Subject: Re: [PATCH -v3] flat: fix data sections alignment
From: Mike Frysinger <vapier.adi@gmail.com>
To: Johannes Weiner <jw@emlix.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>, os@emlix.com, dhowells@redhat.com,
       rmk@arm.linux.org.uk, cooloney@kernel.org, geert@linux-m68k.org,
       gerg@uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 9, 2009 at 10:25, Johannes Weiner wrote:
> On Thu, Apr 02, 2009 at 01:53:43PM -0700, Andrew Morton wrote:
>> On Tue, 10 Mar 2009 16:33:50 +0900
>> Paul Mundt <lethal@linux-sh.org> wrote:
>>
>> > On Thu, Mar 05, 2009 at 06:00:59PM +0100, Oskar Schirmer wrote:
>> > > The flat loader uses an architecture's flat_stack_align() to align the
>> > > stack but assumes word-alignment is enough for the data sections.
>> > >
>> > > However, on the Xtensa S6000 we have registers up to 128bit width
>> > > which can be used from userspace and therefor need userspace stack and
>> > > data-section alignment of at least this size.
>> > >
>> > > This patch drops flat_stack_align() and uses the same alignment that
>> > > is required for slab caches, ARCH_SLAB_MINALIGN, or wordsize if it's
>> > > not defined by the architecture.
>> > >
>> > > It also fixes m32r which was obviously kaput, aligning an
>> > > uninitialized stack entry instead of the stack pointer.
>> > >
>> > > Signed-off-by: Oskar Schirmer <os@emlix.com>
>> > > Signed-off-by: Johannes Weiner <jw@emlix.com>
>> > > Cc: David Howells <dhowells@redhat.com>
>> > > Cc: Russell King <rmk@arm.linux.org.uk>
>> > > Cc: Bryan Wu <cooloney@kernel.org>
>> > > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
>> > > Cc: Paul Mundt <lethal@linux-sh.org>
>> > > Cc: Greg Ungerer <gerg@uclinux.org>
>> > > Cc: Mike Frysinger <vapier.adi@gmail.com>
>> >
>> > The updated version looks ok to me anyways, and it's certainly an
>> > improvement over defining the same alignment requirements all over the
>> > place.
>> >
>> > Acked-by: Paul Mundt <lethal@linux-sh.org>
>>
>> Quite a few people expressed quite a few reservations over v2.
>>
>> Are we all OK with a v3 merge?
>
> Paul and Mike had complaints.  Paul acked the last revision.  Mike?
> We need this for upstream to compile on our configuration.

i thought my comments had all been addressed, so i dont have any problems
-mike
