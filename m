Return-Path: <linux-kernel-owner+w=401wt.eu-S1756674AbZFIBB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbZFIBB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 21:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbZFIBBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 21:01:19 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:42802 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbZFIBBT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 21:01:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jRWyQ1iTwC1xLZ6vku0bz8ciRMsp6f05w/JD41X2Tw2R+exYc+y+dYtYWcrqixaR8o
         rJaYKC/24UK0mfMSqPS8A6nfHOJuayxacny8NMk7E5QMdNtn3uJGigs3YesQ0RbZNkCR
         9ijqUg8YvVITD/20xU3n8c/AejN0Wx668FjRw=
MIME-Version: 1.0
In-Reply-To: <20090608143913.749e19c5.akpm@linux-foundation.org>
References: <a8e1da0906080040k7852f770v1e2aa2ebb0f52369@mail.gmail.com>
	 <20090608081439.GB6372@elte.hu>
	 <20090608012845.9c428525.akpm@linux-foundation.org>
	 <a8e1da0906080142u62a45c47g2181a79addfb6168@mail.gmail.com>
	 <20090608084807.GE6372@elte.hu>
	 <20090608092607.8b331bf0.akpm@linux-foundation.org>
	 <20090608171501.GA15399@elte.hu>
	 <20090608143913.749e19c5.akpm@linux-foundation.org>
Date: Tue, 9 Jun 2009 09:01:19 +0800
Message-ID: <a8e1da0906081801j7169bec1ja1242dcea1aaba7d@mail.gmail.com>
Subject: Re: [PATCH v3] printk: add halt_delay parameter for printk delay in 
	halt phase
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 9, 2009 at 5:39 AM, Andrew Morton<akpm@linux-foundation.org> wrote:
> On Mon, 8 Jun 2009 19:15:01 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
>
>> > questions: is it possible for interrupts to be disabled at this
>> > time? If so, can we get an NMI watchdog hit?
>>
>> no, we generally turn off the nmi watchdog during shutdown, disable
>> the lapic and io-apic, etc.
>
> Is x86 the only architecture which implements an NMI watchdog?
>
>> > Is the softlockup detector still running and if so, can it
>> > trigger?
>>
>> in (non-emergency) reboot, last i checked, we stopped all other CPUs
>> first, and then killed the current one. There's no chance for the
>> watchdog thread to run.
>
> OK, but...  See below.
>
>> Anyway ... you seem to be uncomfortable about this patch - should i
>> delay it for now to let it all play out? We are close to the merge
>> window.
>
> I'm OK - I'm just bouncing ideas and questions off you guys, to make sure
> that we've thought this through all the way.
>
> Here's another: why is it a boot option rather than a runtime-tunable?
> A /proc tweakable is generally preferable because it avoids the
> oh-crap-i-forgot-to-edit-grub.conf thing.  And we could perhaps then
> remove all those system_state tests: userspace sets printk_delay
> immediately prior to running halt/reboot/etc?

Andrew, thanks your comments.
I original intention is to use not boot options but sysfs interface.
Do you perfer proc?
without system_state testing we will have to consider the NMI watchdog
and softlockup issue.

>
> Plus the feature becomes more general - perhaps there are use cases
> where people want to slow down printks, such as: kernel goes oops, data
> scrolls off, serial console/netconsole unavailable.  pause_on_oops is
> supposed to help here but last time I tried it, it kinda didn't work,
> plus pause_on_oops doesn't solve the data-scrolled-off problem.

Seems make sense.

>
> Thirdly, if we do this as a general /proc/printk_delay thing, perhaps
> it can be consolidated with the existing boot_delay= implementation.
>



-- 
Regards
dave
