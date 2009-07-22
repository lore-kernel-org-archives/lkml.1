Return-Path: <linux-kernel-owner+w=401wt.eu-S1753674AbZGVSvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbZGVSvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 14:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbZGVSvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 14:51:12 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:51266 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbZGVSvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 14:51:11 -0400
Message-ID: <4A675F89.50506@nortel.com>
Date: Wed, 22 Jul 2009 12:50:49 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: question for C preprocessor wizards
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jul 2009 18:50:51.0291 (UTC) FILETIME=[559E1EB0:01CA0AFD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm hoping someone can help me out.

I've got a bunch of code that call a bunch of different wrapper
routines, with varying numbers of arguments.  Depending on whether a
compile flag is set, I want to do some stuff before and after calling
the "real" routine.  I can do this easily enough with a macro.

#if FLAG
#define func_wrapper(args...) \
	do { \
		dostuff(); \
		func(args); \
		do_more_stuff(); \
	} while (0)
#else
#define func_wrapper(args...) func(args)
#endif


However, given that there are hundreds of functions, I'd like to
generate these macros with another macro, sort of like:

#if FLAG
#define WRAPPER(func) \
	#define func # _wrapper(args...) \
	do { \
		dostuff(); \
		func(args); \
		do_more_stuff(); \
	} while (0)
#else
#define WRAPPER(func) \
	#define func ## _wrapper(args...) func(args)
#endif

Where I could then do

WRAPPER(func1)
WRAPPER(func2)
...
WRAPPER(func100)


However, the preprocessor complains about having that "#" in the macro
body where it isn't used for stringification.


Anyone have any ideas how to accomplish this?  I had considered writing
an app to programmatically generate an include file as a precursor to
actually compiling the real app, but I was hoping there was a more
elegant solution.

Thanks,

Chris

