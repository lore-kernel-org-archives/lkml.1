Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493AbYFCP1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbYFCP1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 11:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbYFCP1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 11:27:08 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:11315 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbYFCP1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 11:27:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uDJk6g0lpb/IbhnJbvtDYyKBNe5KMYcgaCczUv0LY4kDqG3ENbiNKMghxdCzjEGuoD6uG3j0j/JquuEL+lSoKmjiveJHKEuMJYsGd9Tm1EUmJrCdcAQP4UIDR6+Bvn5IvuefIQ9KbSimWmJmOZgPCzaVS2CvJeqK2KNSgUejYj4=
Message-ID: <863e9df20806030827n41942f28i30fe3d45b10df6ae@mail.gmail.com>
Date: Tue, 3 Jun 2008 20:57:05 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 0/3][RFC] ftrace: track dynamic ftrace update failures
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0806030858500.20107@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4842CB8F.2000702@gmail.com>
	 <Pine.LNX.4.58.0806021354520.10366@gandalf.stny.rr.com>
	 <863e9df20806022113w339257b1pa4c8a7762bab8bc1@mail.gmail.com>
	 <Pine.LNX.4.58.0806030858500.20107@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 3, 2008 at 6:30 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Can we add an API to kprobes or perhaps a way to register code
> modification in ftrace, that ftrace can ignore? Let the two know about
> each other, but in a way that they dont need to know the internals of one
> another.

There's a get_kprobe() already which can tell if an address's kprobed
or not. But still doesn't stop kprobe from forcing change on mcount
sites and fooling ftrace like mentioned previously. The
problem with maintaining a blacklist sort of thing for kprobed mcount
sites may also be an
overkill since it can permanently make that function un-ftraceable.

One kprobe specific measure can be to provide notifiers in
[un]register_kprobe(). Ftrace can
listen on register event to temporarily disable tracing of the
corresponding function by forcing
a NOP at the mcount site just before a kprobe is placed on it, if it's
already recorded/enabled.
The tracing can be enabled back when the corresponding unregister
event is received. Worth a
shot?

--
Regards,
Abhishek Sagar
