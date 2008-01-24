Return-Path: <linux-kernel-owner+w=401wt.eu-S1759399AbYAXV3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399AbYAXV3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 16:29:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756146AbYAXV3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 16:29:24 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:45179 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756717AbYAXV3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 16:29:23 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAPiRmEdMQWYq/2dsb2JhbACBV61k
Date: Thu, 24 Jan 2008 16:18:54 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 07/26] Add INIT_ARRAY() to kernel.h (updated)
Message-ID: <20080124211854.GA2181@Krystal>
References: <20080124202706.250598537@polymtl.ca> <20080124203335.082459062@polymtl.ca> <Pine.LNX.4.64.0801242137020.12676@fbirervta.pbzchgretzou.qr> <20080124205434.GC31333@Krystal> <Pine.LNX.4.64.0801242206300.12676@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801242206300.12676@fbirervta.pbzchgretzou.qr>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:13:20 up 82 days,  2:18,  6 users,  load average: 0.22, 0.37,
	0.87
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jan Engelhardt (jengelh@computergmbh.de) wrote:
> 
> On Jan 24 2008 15:54, Mathieu Desnoyers wrote:
> >
> >Add initialization of an array, which needs brackets that would pollute kernel
> >code, to kernel.h. It is used to declare arguments passed as function parameters
> >such as:
> >text_poke(addr, INIT_ARRAY(unsigned char, 0xf0, len), len);
> >
> >Changelog :
> >- [len] -> []
> >- Remove whitespaces.
> >- Fixed Jan's suggestion which was not checkpatch.pl-safe.
> 
> diff -dpru /dev/null <(echo '  #define INIT_ARRAY(type, val, len) ((type[]){[0 ... (len)-1] = (val)}) ') | scripts/checkpatch.pl -
> ERROR: Missing Signed-off-by: line(s)
> total: 1 errors, 0 warnings, 2 lines checked
> 
> Where did checkpatch play unfair again on your side? :)
> 

Hrm, I don't know why checkpatch does not notice the problem when
invoked with your command, but creating a patch with your change results
in :

compudj@dijkstra:~/git/morestable/linux-2.6-lttng.mm$ scripts/checkpatch.pl patches/test.patch 
ERROR: need a space before the open brace '{'
#27: FILE: include/linux/kernel.h:426:
+#define INIT_ARRAY(type, val, len) ((type[]){[0 ... (len)-1] = (val)})

total: 1 errors, 0 warnings, 6 lines checked

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

but I guess we are deep down in nitpicking land ;)

Cheers,

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
