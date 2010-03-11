Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab0CKCW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 21:22:28 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56062 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab0CKCW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 21:22:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=tOE/SqHtYhaebdJwwT/EaLkJ6EDMD2ReMpczeR+4a9XBMJmESBOWtQa3BVPbzOE8EJ
         01UmsqRb6r43f0TpvdvHUafJBcFt4MvSMAZ0jQLtmKReNW8jnIGJcTEORZ9lOHi2Z5b6
         RgcQdU27bB9NddcU4f1MnWH+AaX4ZO2Jzydbk=
MIME-Version: 1.0
Date: Wed, 10 Mar 2010 21:22:23 -0500
X-Google-Sender-Auth: 0762c0370a8ac41b
Message-ID: <40ec3ea41003101822q1f44b393y198d693c59792969@mail.gmail.com>
Subject: Re: [regression]: soft lockup in dmesg after suspend/resume
From: Chase Douglas <chase.douglas@canonical.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wanted to ask about potential work arounds for the issue noted at
[1]. I wasn't subscribed to this list when that thread was started, so
unfortunately I can't reply directly. I also haven't found any follow
up to the thread, but please point me in the right direction if there
has been any.

We're seeing a number of reports against Ubuntu Lucid caused by
timestamps being highly warped coming out of suspend/resume. When a
warp occurs, the TSC register is throwing off timestamps with the
upper 32 bits set to 0xFFFFFFFF. I'm not terribly familiar with the
TSC or x86 clocking in general, but such time stamps should be many
many years into the future before we see them (unless I've done my
math wrong :). So with that in mind, it seems that it should be
possible to test for such outlandish values coming out of
suspend/resume. If the values are warped, would it be safe to switch
over to using jiffies in native_sched_clock by setting tsc_disable=1
during runtime?

Thanks,
Chase

[1] http://lkml.org/lkml/2010/1/4/7
