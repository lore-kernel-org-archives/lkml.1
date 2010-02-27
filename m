Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030572Ab0B0Sg2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 13:36:28 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33810 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030419Ab0B0Sg1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 13:36:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ayBpXR8uj3tCsqlq7Nomsa0cbDXfqFh6KVRz5BPPh7aZ6WpZ5YthJCU/xty1Sgev+z
         Ho7iGv58K2RmeYqrw7hwd/gYr4Bo5FdNQkVA4/2Wq/gWy7OT+zqXDZSV7eaYDv/SIgbH
         7nP3UuPGa6VW1A91Ba/x+L5sg5cyY0YCVcbcM=
MIME-Version: 1.0
In-Reply-To: <201002262302.18890.david-b@pacbell.net>
References: <cover.1267225701.git.gardner.ben@gmail.com>
	 <14e456b7d269efd860bb36c312de2bc4ad504dca.1267225701.git.gardner.ben@gmail.com>
	 <201002262302.18890.david-b@pacbell.net>
Date: Sat, 27 Feb 2010 12:36:24 -0600
Message-ID: <808c8e9d1002271036s387b4638u9c754da1e88b6e1b@mail.gmail.com>
Subject: Re: [PATCH 1/3] gpiolib: add gpio_set_direction()
From: Ben Gardner <gardner.ben@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, Andres Salomon <dilinger@collabora.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> NAK.
>
> When we discussed the programming interface originally, having the
> direction be part of the function name was explicitly requested as
> a way to reduce programming errors.
>
> I recall that  a gpio_set_direction() was in the original proposal...
> removing that was one of the handful of fixes that went into the final
> set of calls in this programming interface.
>
> And in fact  ... it *was* very easy to make errors with a few GPIO
> interfaces which worked like that.  With even fewer parameters to
> create confusion than in your proposal.
>
> Let's have no retrograde motion...
>
>
>> Add 'none' and 'inout' directions to the sysfs interface.
>
> Both of those seem nonsensical:
>
>  "none" ... since it's not even a GPIO, why would it show
>        up through the GPIO subsystem???
>
>  "inout" ... is not a direction.  But if you want to do this,
>        you really ought to bite the bullet and come up with a
>        way the implementation can pass up its capabilities.
>
>        Did you read the definition of gpio_get_value()?  It says
>        "When reading the value of an output pin, the value returned
>        should be what's seen on the pin ... that won't always match
>        the specified output value, because of issues including
>        open-drain signaling and output latencies."  Also:  "note that
>        not all platforms can read the value of output pins; those that
>        can't should always return zero."
>
>        Another way to say that is that "output" means 'inout" except
>        when the platform can't do that.  So you'd need to address the
>        case of hardware that's truly output-only ... instead of
>        ignoring that, as done here.  (That is:  you'd need to have a
>        way to reject "inout" mode ... or for that matter, "output-only".)
>
>
>        Doing that well might be a Good Thing ... if for example it
>        lets the initial mode of a GPIO show up properly ... there's
>        currently an assumption in sysfs that they start up as "input",
>        which of course makes sense for any power-sensitive system
>        (you don't enable output drivers unless that power consumption
>        is for some reason required).
>
>        I've never, for example, seen GPIO hardware that would support
>        the equivalent of that "open in <bitmask> mode".   It's either
>        unidirectional (rarely), or (normally) the only real option is
>        whether the output drivers are disabled.  So you always get the
>        "inout" semantics described above, or input-only ones.  Asking
>        for output-only would need to fail.  (Or in the less typical
>        cases, it's asking for "inout" that would need to fail.)

OK. Lets dump this patch series and I'll send off a patch that fixes
the cs5535-gpio driver to behave as indicated.

Ben
