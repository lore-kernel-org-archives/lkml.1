Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbXDOWyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbXDOWyn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 18:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbXDOWyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 18:54:43 -0400
Received: from mx34.mail.ru ([194.67.23.200]:18700 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754044AbXDOWym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 18:54:42 -0400
Date: Mon, 16 Apr 2007 02:50:49 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Ondrej Zajicek <santiago@crfreenet.org>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       dwmw2@infradead.org
Subject: Re: [PATCH 3/7] [RFC] Battery monitoring class
Message-ID: <20070415225049.GA27680@zarina>
Reply-To: cbou@mail.ru
References: <20070411232503.GC20095@zarina> <20070415220854.GA20373@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070415220854.GA20373@localhost.localdomain>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Apr 16, 2007 at 12:08:54AM +0200, Ondrej Zajicek wrote:
> On Thu, Apr 12, 2007 at 03:25:03AM +0400, Anton Vorontsov wrote:
> > Here is battery monitor class. According to first copyright string, we're
> > maintaining it since 2003. I've took few days and cleaned it up to be
> > more suitable for mainline inclusion.
> 
> Just some ideas:
> 
> - what about using exponents in values?
> For example file "voltage" could contain "123 -3" to represent 123 mV.
> Exponents could be hardcoded in drivers according to device's range
> (so there is no complication in it), but interface is usable in great
> range of values. And it is pretty easy to use from userspace.

No, sorry. Common units is main goal of that class. If you're saying
"energy" you always know that it's uWh. It's better for both userspace
(don't bother to parse anything from kernel) and kernel itself.

No need to invent new kernel<->userspace protocols, no need to do
useless string manipulations in kernel itself.

> - interface should allow to present values which are some monotonic
> functions of common physical properties. For example when we know
> where are some raw data from sensor, but we don't know where are
> calibration tables to be able to compute value in some standard unit
> (as V for voltage) - in this case it is better to show raw data 
> (or raw data after some transformation which makes them monotonic)
> and specify that this is raw data than show nothing. 
> 
> - it would be nice to know whether presented value is from some
> measurement or it is (inaccurate) estimation.

Current battery class assumes values are not averaged. I.e. momentary
values. In general, it's userspace' job to collect statistics. Though,
if hardware can report only average values, it's just okay to use
usual attributes.

Also, if you your battery can collect and report its approximated values
in additional to momentary values, you're free to add _AVG attributes
to standard ones and use them.

> -- 
> Elen sila lumenn' omentielvo
> 
> Ondrej 'SanTiago' Zajicek (email: santiago@mail.cz, jabber: santiago@njs.netlab.cz)
> OpenPGP encrypted e-mails preferred (KeyID 0x11DEADC3, wwwkeys.pgp.net)
> "To err is human -- to blame it on a computer is even more so."

Thanks for comments!

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
