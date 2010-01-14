Return-Path: <linux-kernel-owner+w=401wt.eu-S1757436Ab0ANSCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436Ab0ANSCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 13:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757257Ab0ANSCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 13:02:45 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:34124 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757398Ab0ANSCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 13:02:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=WfvIwPYcdLfpbh1ATwMU0EoQfTEsmKD5QQlJC+KDPxLQemraZs4PAwpDVB/Q6ibszl
         o3egHV1IVrMv1bCDN97Hqemdb96mGQUsVPOOP7kr9gHmJTujYHEMAAD6/++3Z4v8Eqio
         h+wwLZqwD8uYIR0Vztnqh8m8Xi/S2/GB32pjk=
MIME-Version: 1.0
In-Reply-To: <1263458665.4244.256.camel@laptop>
References: <bc915a051001131745m6fb70dcbx29b9d35f6fd7106c@mail.gmail.com>
	 <1263458665.4244.256.camel@laptop>
Date: Thu, 14 Jan 2010 10:02:44 -0800
Message-ID: <bc915a051001141002h3ed92e75o95318fa2f8a20d21@mail.gmail.com>
Subject: Re: HW breakpoints perf_events request
From: Joshua Pincus <joshua.pincus@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>, paulus@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Thu, Jan 14, 2010 at 12:44 AM, Peter Zijlstra
> We have fnctl() managing signal support, but that will only interrupt
> the observing thread, not the threads being observed (unless they are
> one and the same -- but using inheritance precludes that from being
> true).
>
> I'm not sure I'm willing to go in this direction with perf, the idea is
> to have a minimum impact on the observed threads, explicitly sending
> them signals and disturbing their execution goes against this.

I understand your qualms.

I'm not asking for this feature to be implemented as the
default.  I'm asking that it be an option for someone like me to use.
We have a very strong
and compelling reason for doing what I've requested
vis a vis observed threads.  I am sure we can come up
with other compelling reasons for doing this, not the least
of which is that this functionality has been provided
in Microsoft Windows for a decade or more and has
proven immensely useful.

For instance, one could use this as a realtime watchdog
without requiring extra observing threads to do the
signal processing work.  Or having observed threads
use the signal handler to tally up events.

Without the ability for observed threads to be interrupted
in this way when they hit breakpoints, the new
perf_event work is not going to be useful to us in its
current form.

Thanks,
JP


>
>
