Return-Path: <linux-kernel-owner+w=401wt.eu-S1753727AbZBQErD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbZBQErD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 23:47:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbZBQEqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 23:46:53 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:34263 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbZBQEqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 23:46:52 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18842.16695.145336.851447@stoffel.org>
Date: Mon, 16 Feb 2009 23:46:47 -0500
From: "John Stoffel" <john@stoffel.org>
To: Philippe Grenard <philippe.grenard@laposte.net>
Cc: linux-kernel@vger.kernel.org, "John Stoffel" <john@stoffel.org>
Subject: Re: PROBLEM: cannot get stable system since 2.6.28 kernel (amd64)
In-Reply-To: <200902161925.40256.philippe.grenard@laposte.net>
References: <200902131944.56634.philippe.grenard@laposte.net>
	<200902151317.11690.philippe.grenard@laposte.net>
	<18840.45474.829954.528820@stoffel.org>
	<200902161925.40256.philippe.grenard@laposte.net>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Philippe" == Philippe Grenard <philippe.grenard@laposte.net> writes:

Philippe> well, I don't really believe in hardware problem for two
Philippe> reasons : 1st, nearly all my hardware is quite new ( < 1
Philippe> year old ), which is, I agree, not a solid proof ;-) 2nd,
Philippe> the problem is really repetitive : every time I boot on
Philippe> older kernel, everything works like a charm, every time I
Philippe> boot on the newer kernel, I end up crashing : the "random"
Philippe> part is only the time before crash....

Philippe> I haven't any "overclocking" settings, and every hardware
Philippe> and bios settings are the same : same computer, same
Philippe> harddisk partition, and so on.  2.6.28 will everytime stop
Philippe> after "Booting the kernel".  2.6.29-rc* will boot, but then
Philippe> stalls after a random delay... Except the "/proc/cpuinfo"
Philippe> difference between the two kernels, I don't have a clue....

Philippe> The thing is I can continue using the old kernel, but I
Philippe> thought I better report this since It could hide some
Philippe> regression on amd64 systems ?

It's certainly sounding like a regression, or misconfiguration
somewhere.  Can you start doing a 'git bisect' routine on this to see
if you can find the commit which causes this regression?

It will take around 10 or some recompiles and reboots, but should do
the trick, or at least help narrow things down alot.  Read
Documentation/BUG-HUNTING ofr how to do a bisect run.  

You could also go back and re-build your 2.6.28 kernel and config from
scratch to confirm that it's really working properly.  Then, jump to
2.6.29-rc5 (just released) and do a 'make oldconfig' and see what
you're prompted for.  If it still crashes, send us the original
config, and a diff to the new config (diff -u) so we can look it over.

Also, make sure you're not running *any* binary kernel modules, since
that will make us completely ignore you.  We can't debug issues like
this when nVidia graphics modules are in the system since we can't
tell what that module does to the rest of the kernel and it's not
worth ou time to figure out.

I'm running 2.6.29-rc3 on my AMD64 system and it's been nice and
stable and my hardware too is under a year old.  

John

