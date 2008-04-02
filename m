Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbYDBOgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbYDBOgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 10:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757252AbYDBOgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 10:36:33 -0400
Received: from relay1.sgi.com ([192.48.171.29]:58503 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754912AbYDBOgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 10:36:32 -0400
Message-ID: <47F399EE.4080704@sgi.com>
Date: Wed, 02 Apr 2008 07:36:30 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: add cpuset_scnprintf function
References: <20080401225422.064890000@polaris-admin.engr.sgi.com> <20080402012006.1722c2bd.pj@sgi.com>
In-Reply-To: <20080402012006.1722c2bd.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Paul Jackson wrote:
...
>  1) I'm surprised to see this new routine called 'cpuset_scnprintf'
>     (with the "cpuset" prefix), rather than a variant of a trio of
>     names with prefixes of bitmap_, cpumask_, and nodemask_, like
>     the other print routines in the bitmap family.  This doesn't
>     seem to be a cpuset function to me, but a bitmap (and derived
>     types cpumask and nodemask) printing function.

How about "cpus_scnprintf" to avoid confusion with "cpusets"?

>  2) The idea of the patch, that being a kernel modal flag that if
>     set, changes a few particular details of the kernel API for all,
>     seems like something I'd rarely want to do, unless I was really
>     short of other options.  It leads to one app breaking another
>     as a result of changing this mode, and to head butting between
>     apps which cannot agree on how to set the mode.  And it introduces
>     the option of breaking an existing API, which is seldom a good
>     option.

I could preface the cpulist_scnprintf output with '+' so a user app
could then:

        if (buf[0] == '+')
                bitmask_parselist(&buf[1], ...)
        else
                bitmask_parsehex(buf, ...)

or the perl equivalent which is probably more prevalent.

[I'll put this into the Documentation for compat_cpus_scnprintf...]

Does this sufficiently satisfy your concerns?  It stays compatible with
the current method, but provides an avenue for future growth...?

> Kernel API's visible to kernel drivers or loadable modules have a
> higher barrier to change.

> Kernel API's visible to user space, such as this one, have a much
> higher barrier to incompatible change.

But where is the API spec for /proc outputs?  I'd like to see how others
have managed to change it in the past, and what are the rules for doing so.

> I hesitate to NAQ patches because I strike out more often than someone
> like Al Viro.  But I'm getting tempted on this one.
> 
> Perhaps you could write yourself a user utility that scanned its input
> for masks in legacy format, converted them to list format, and passed
> all else unscathed?

Or write a utility to convert the more compact readable format into the
incomprehensible one and output that ... ?  ;-)

Thanks,
Mike
