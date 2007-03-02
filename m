Return-Path: <linux-kernel-owner+w=401wt.eu-S933365AbXCBSuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365AbXCBSuP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 13:50:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933367AbXCBSuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 13:50:15 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:45160 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933365AbXCBSuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 13:50:14 -0500
Date: Fri, 2 Mar 2007 19:50:35 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: FN <zzzz444@ml1.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: module builds need improvement / top Makefile not good enough
Message-ID: <20070302185035.GA19305@uranus.ravnborg.org>
References: <1172855662.23830.1177403935@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172855662.23830.1177403935@webmail.messagingengine.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 09:14:22AM -0800, FN wrote:
> Hello list,
> 
> I am unhappy with the direction the 2.6 kernel builds have taken.
> Very much like Micro$loth DDKs we (linux users) are being forced to
> build
> modules by plugging into a framework that doesn't respect the fine
> aspects
> of dependency generation and analysis.

The build system for the kernel (kbuild) have a number of goals to fulfill.
The most important ones was to be reliable and easy to use.
The easy to use part has mandated a very simple syntax in the
more than 1000 Makefiles in the kernel - and kbuild has been extended
support external modules too.

With the 2.6 kernel it is mandatory to use kbuild for external
modules for a number of reasons:
-> compiler and to some extent linker options now much more rely on
   the actual configuration. So a gcc commandline for a module may look
   different depending on the actual configuration.

-> The module support code is well integrated with kbuildand when
   it changes (and it does so now and then) then all external modules
   do not need to apply the same changes.

-> Same syntax for in-kernel and external modules makes it simpler.


The infrastructure used to achieve the goals of simplicity and reliability
rely and a great deal of the features supported by GNU make and that
clearmake and others does not support.
So faced with the two possibilities which is 
1) to rely on less GNU make features and support other make tools
2) full feature set but rely on GNU make
the choice was easy.

The point here is that even if kbuild was changed slightly to allow a user
to specify an alternative make program when building external modules
that would not work because kbuild rely too much on the GNU make features.

You can try this today.
MAKE=/usr/bin/my_make_utility make M=`pwd`

And see how it fails due to use of GNU make features.

	Sam
