Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbYGZSxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbYGZSxZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 14:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbYGZSxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 14:53:17 -0400
Received: from qb-out-0506.google.com ([72.14.204.238]:53902 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYGZSxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 14:53:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references
         :in-reply-to:content-type:content-transfer-encoding:from;
        b=P70WtVGtUv3+IGw7EYKUbrWH/xw5Wk/HARcjQilsOMHIGnejphKwWKSoC2cenk3q50
         N8xr8hJZAXTSHP63X+dhrFQoKgFvXXELALVqmpn2pVBrjdO5fR9c82M+vLF+TnxdbDkO
         eI1aZNnAS3byC/9bj0YGkFGl0ky6pwuaezuMk=
Message-ID: <488B7297.8090405@gmail.com>
Date: Sat, 26 Jul 2008 14:53:11 -0400
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Glauber Costa <glommer@gmail.com>
CC: linux-kernel@vger.kernel.org, gcosta@redhat.com
Subject: Re: [Bisected] Regression: Hang on boot in schedule_timeout_interruptible
 during ACPI init on SMP
References: <4887B4D5.1050306@gmail.com> <5d6222a80807231731u41f9fb81w2796b3db1a5920e6@mail.gmail.com>
In-Reply-To: <5d6222a80807231731u41f9fb81w2796b3db1a5920e6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Andrew Drake <zappacky.lists@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just discovered; the nolapic_timer parameter causes the problem to go away 
entirely. It doesn't seem to have any nasty side effects, so I'm content to use 
it. Looking at the dmesg logs, however, I notice that the "last-good" kernel 
doesn't even try to use the LAPIC timer, but the "first-bad" does. I wasn't able 
to track down any discernible reason.

On a side note, that's the first I've ever heard/seen of that parameter, I tried 
it because I noticed the problems started when the LAPIC timer was successfully 
set up. I doubt the average user would notice this (you can't even tell unless 
you pass apic=debug), so I doubt many others would discover this fix/workaround.

The question remains, though, why did it go from "don't try" to "try"?

Thanks,

Andrew

