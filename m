Return-Path: <linux-kernel-owner+w=401wt.eu-S1753715AbZGZP5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbZGZP5y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 11:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZGZP5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 11:57:54 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:63765 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbZGZP5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 11:57:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fft083xakD2M2p5MHhKg4WzgrHriiP466qQiee2U425DR06/CWZjTCsVWqq97S0+0/
         2MYzwIsNWHm1cmlI2ZJKofJamJFDr8GCEjeSPpQu67f5EGbppZOw8/GVCP1OIpTUEWYU
         tR7wsIrsspm0fytnGZC4qPO0x1x+3WNkTAoh8=
MIME-Version: 1.0
In-Reply-To: <81b0412b0907260846i1cce0e81m6c7bf99263fb4c1@mail.gmail.com>
References: <1246510598-6136-1-git-send-email-keithp@keithp.com>
	 <1246536889.22562.74.camel@dhcp235-23.rdu.redhat.com>
	 <81b0412b0907260846i1cce0e81m6c7bf99263fb4c1@mail.gmail.com>
Date: Sun, 26 Jul 2009 17:57:50 +0200
Message-ID: <81b0412b0907260857q15376026x7fae3e708f33ff74@mail.gmail.com>
Subject: Re: [PATCH] fs/notify/inotify: decrement user inotify count on close
From: Alex Riesen <raa.lkml@gmail.com>
To: Eric Paris <eparis@redhat.com>
Cc: Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org,
       john@johnmccutchan.com, rlove@rlove.org, eparis@parisplace.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 26, 2009 at 17:46, Alex Riesen<raa.lkml@gmail.com> wrote:
> On Thu, Jul 2, 2009 at 14:14, Eric Paris<eparis@redhat.com> wrote:
>> On Wed, 2009-07-01 at 21:56 -0700, Keith Packard wrote:
>>> The per-user inotify_devs value is incremented each time a new file is
>>> allocated, but never decremented. This led to inotify_init failing after a
>>> limited number of calls.
>>>
>>> Signed-off-by: Keith Packard <keithp@keithp.com>
>>
>> Thanks, I will push to Linus later today, sorry about the regression!
>>
>
> Hmm... Either the patch wasn't enough, or it was broken again.

The bug seem to be known since 2.6.28:

   http://bugzilla.kernel.org/show_bug.cgi?id=12754
