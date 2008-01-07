Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbYAGKJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbYAGKJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 05:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbYAGKJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 05:09:26 -0500
Received: from fmmailgate05.web.de ([217.72.192.243]:52451 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbYAGKJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 05:09:25 -0500
Date: Mon, 07 Jan 2008 11:09:23 +0100
Message-Id: <90564384@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: arjan@infradead.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: =?iso-8859-15?Q?Re:_[patch_1/2]_show_being-loaded/being-unloaded_indic?=
 =?iso-8859-15?Q?ator_for_modules?=
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+KBn3WYmX0ZmtvX7EhYPRIMR9hnkGvwwkCH3uikfBFxBN9W
 /xybkP8/2QqEeU29VeGVvZdxfTcg42LKCv/r1hyuIEFEugu+1g=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this looks very useful!

>Unfortunatly, it's not always easy to see directly
>which module is being loaded/unloaded from the oops itself.

no wonder, as most modules seem to be very quiet on on load/unload.

some days ago i was curious how "consistent" modules would leave messages in syslog load/unload.
this is why i made a little statistic on that.

i`d like to share the essential part here (can provide more details if you like):

on load, 1204 on unload, 1655 (out of 2088) left absoultely _no_ message in syslog           


example:

3c359 - silence
3c501 - silence
3c503 - 2 lines on load, 0 on unload
3c505 - 3 lines on load, 0 on unload
3c507 - silence
3c509 - silence
3c515 - 1 line on load, 0 on unload
3c574_cs - silence
3c589_cs - silence
3c59x  - silence

ok, this is not too reliable, because modules might act differently if they find appropriate hardware.

but i wonder if some mandatory "print a message on init/exit" wouldn`t give a benefit to admins or end-users, too.
sure this would additionally clutter up syslog, but it would add transparency.

if modules can print informations like credits, email-adresses and path-to-the-source-files, why not some mandatory message on load/unload then....


>List:       linux-kernel
>Subject:    [patch 1/2] show being-loaded/being-unloaded indicator for modules
>From:       Arjan van de Ven <arjan () infradead ! org>
>Date:       2008-01-06 23:18:50
>Message-ID: 20080106151850.3eab58b0 () laptopd505 ! fenrus ! org
>[Download message RAW]
>
>Subject: show being-loaded/being-unloaded indicator for modules in oopses
>From: Arjan van de Ven <arjan@linux.intel.com>
>CC: rusty@rustcorp.com.au
>CC: ak@suse.de
>CC: mingo@elte.hu
>
>It's rather common that an oops/WARN_ON/BUG happens during the load or
>unload of a module. Unfortunatly, it's not always easy to see directly
>which module is being loaded/unloaded from the oops itself. Worse,
>it's not even always possible to ask the bug reporter, since there
>are so many components (udev etc) that auto-load modules that there's
>a good chance that even the reporter doesn't know which module this is.
>
>This patch extends the existing "show if it's tainting" print code,
>which is used as part of printing the modules in the oops/BUG/WARN_ON
>to include a "+" for "being loaded" and a "-" for "being unloaded".

>As a result this extension, the "taint_flags()" function gets renamed to
>"module_flags()" (and takes a module struct as argument, not a taint
>flags int).

_____________________________________________________________________
Der WEB.DE SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!
http://smartsurfer.web.de/?mc=100071&distributionid=000000000066

