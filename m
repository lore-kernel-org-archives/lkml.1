Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbYAQIP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbYAQIP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 03:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbYAQIPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 03:15:51 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:5210
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752323AbYAQIPv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 03:15:51 -0500
Message-Id: <478F1CDD.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 17 Jan 2008 08:16:13 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "David Brownell" <david-b@pacbell.net>
Cc: "Roman Zippel" <zippel@linux-m68k.org>,
       "lkml" <linux-kernel@vger.kernel.org>,
       "Randy Dunlap" <rdunlap@xenotime.net>
Subject: Re: 2.6.23-git Kconfig regression
References: <20071020012245.9B3FB23A5F7@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <20071019202140.ecbc4a0d.rdunlap@xenotime.net>
 <478DDC79.76E4.0078.0@novell.com> <200801161602.01557.david-b@pacbell.net>
In-Reply-To: <200801161602.01557.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> David Brownell <david-b@pacbell.net> 17.01.08 01:02 >>>
>On Wednesday 16 January 2008, Jan Beulich wrote:
>> >>> Randy Dunlap <rdunlap@xenotime.net> 20.10.07 05:21 >>>
>> 
>> Sorry for only now getting back to this.
>> 
>> >On Fri, 19 Oct 2007 19:55:35 -0700 Randy Dunlap wrote:
>> >
>> ...
>> 
>> I'm pretty convinced that drivers/usb/gadget/Kconfig isn't really
>> written properly:
>
>That's orthogonal to whether that patch caused a regression,
>of course.  The operational semantics have, except when they
>were changed, been that it did what it needed to do.
>
>
>> These prompt-less items should go after the choice (resulting 
>> in the choice to become a boolean one),
>
>Maybe -- such a change would have been OK as part of the patch
>which changed the operational semantics of Kconfig.

I simply wasn't aware of dependencies on the hierarchy re-ordering
done inside menu_finalize() within choices, which is what broke this.
And I'm not convinced this hierarchy re-ordering is even fully
consistent in its current shape (i.e. it just happens to work for the
few cases it really is used in).

>>...
>> these options are just pointless except for avoiding
>> 
>> #if defined(CONFIG_...) || defined(CONFIG_..._MODULE)'
>> 
>> in C sources.
>
>Well, avoiding such error-prone idioms would seem good to me.
>They're common enough, and nasty.  But that's not why those
>mechanisms are there.

But nevertheless there are CONFIG_USB_GADGET_* dependencies in
sources. But in a draft re-write of that Kconfig I found an easy way to
keep these anyway, so the point isn't a concern to me anymore.

>> In that latter case, the choice could become a tristate 
>> one, allowing all of the selections to be built at once as modules
>> (which really seems to be the way distro kernels would want to use
>> it) or any one of them to be built in (the current behavior, except
>> that at present even when using these as a module only a single
>> one can be selected).
>
>The requirements are that (a) just one peripheral controller
>driver be selectable, and (b) that it be linked either
>statically or dynamically.  Related, that for the gadget
>drivers (c) none may be selected until the peripheral
>controller driver they'll be used with is known, and either
>(d1) one may be statically linked, or else (d2) any number
>may be built as modules, with only one loaded at a time.

So I'll keep it that way.

>This stuff isn't for "distro" kernels; it's for embedded
>environments of the "only this hardware exists" sort.
>Space matters, and having small code matters.  Nobody has
>been interested enough in an "embedded distro" model to
>provide patches enabling such stuff.

Why not make the whole thing depend on EMBEDDED then? Or is
development for this perhaps being done in non-embedded
environments?

Thanks for the clarification in any case, now I just needs Roman's
opinion on the re-ordering issue in order to come up with a revised
patch.

Jan

