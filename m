Return-Path: <linux-kernel-owner+w=401wt.eu-S932230AbXCETIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230AbXCETIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 14:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932255AbXCETIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 14:08:20 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:51556 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932230AbXCETIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 14:08:19 -0500
Date: Mon, 5 Mar 2007 20:08:52 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: FN <zzzz444@ml1.net>
Cc: Oleg Verych <olecom@flower.upol.cz>, linux-kernel@vger.kernel.org
Subject: Re: module builds need improvement / top Makefile not good enough
Message-ID: <20070305190852.GA9367@uranus.ravnborg.org>
References: <1172855662.23830.1177403935@webmail.messagingengine.com> <E1HNyYT-00086z-27@flower> <1173102794.12256.1177759349@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173102794.12256.1177759349@webmail.messagingengine.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 05:53:14AM -0800, FN wrote:
> | > I am unhappy with the direction the 2.6 kernel builds have taken.
> | > Very much like Micro$loth DDKs we (linux users) are being forced to
> | > build modules by plugging into a framework that doesn't respect the
> fine
> | > aspects of dependency generation and analysis.
> | 
> | Ideas in form of patches are accepted,
> 
> I think that one of the bigger firms that support linux, like IBM,
> Redhat,
> Suse, ought to hire a contractor to redesign kbuild and get the linux
> community involved.

Obviously kbuild can be better and if someone are committed to put in
a month work on kbuild we would see improvements.
As the kbuild maintainer I am the first to agree on this.

kbuild has taken the direction where make is used not only
as a simple DAG tool - be some of the other facilities
has been utilised to support some of the following goals:
-> Very simple Kbuild files for the simple cases - and the simple cases counts
   for more than 95% of the Kbuild files in the kernel.
-> One kbuild file pr. directory for simplicity
-> rebuild in case prerequisites OR referred CONFIG symbol changes
-> rebuild if commandline arguments changes (but not order of these)
-> revert back to known Makefile syntax for complex scenarios
-> make kbuild infrastructure avialable for external modules to make build
   of these more releiable (pick up correct CONFIG)
-> Last but not least - relaible.

These golas are fulfilled by kbuild today.
You want to add another few goals:
-> Do not rely on GNU Make
-> Track actual timestamp/file content to support ClarCase dynamic views


> Currently I face the following situation -- I try to build 2 drivers
> from the same Makefile

If you try to use Kbuild in a way it is not designed to be used
then you will obviously face issues.
One Kbuild file pr. directory.
Use a top-level Kbuild file to specify both sub-directory Kbuild files.

This structure works well for the kernel - so it should work well for your module too?

I am open for specific improvement proposals - but not for 'redo from scratch proposals'.

	Sam
