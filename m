Return-Path: <linux-kernel-owner+w=401wt.eu-S1762877AbZLLCoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762877AbZLLCoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 21:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761500AbZLLCoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 21:44:39 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:53984 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760984AbZLLCoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 21:44:39 -0500
Message-ID: <4B23039C.8040004@ti.com>
Date: Fri, 11 Dec 2009 20:44:44 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>, <linux-kernel@vger.kernel.org>
CC: "Pandita, Vikram" <vikram.pandita@ti.com>
Subject: possible bug in checkpatch.pl with __deprecated?
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy, Folks,

I have two patches of the code. I goofed up on [1] and seemingly fixed 
it on [2] as per checkpatch.pl(I am using pastebin to prevent spamming 
the mailing list - apologies on that). This behavior seems to be related 
to the usage __deprecated with structure fields.

The code in question is:
(fail.patch)
struct omap_opp {
        bool enabled;
        unsigned long rate;
        u8 opp_id __deprecated;
        u16 vsel __deprecated;
};
Vs:
(ok.patch)
struct omap_opp {
        bool enabled;
        unsigned long rate;
        u8 __deprecated opp_id;
        u16 __deprecated vsel;
};

kernel tag used: v2.6.32

$scripts/checkpatch.pl --strict ../fail.patch:

ERROR: space prohibited after that '&&' (ctx:WxW)
#380: FILE: arch/arm/plat-omap/opp.c:25:
+#define OPP_TERM(opp) (!(opp)->rate && !(opp)->vsel && !(opp)->enabled)
                                                      ^

ERROR: space prohibited after that '*' (ctx:WxW)
#389: FILE: arch/arm/plat-omap/opp.c:34:
+	return (((vsel * 125) + 6000)) * 100;
  	               ^

total: 2 errors, 0 warnings, 0 checks, 511 lines checked

../fail.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.


$scripts/checkpatch.pl --strict ../ok.patch
total: 0 errors, 0 warnings, 0 checks, 511 lines checked

../ok.patch has no obvious style problems and is ready for submission.

The failure with fail.patch seems to be a false positive and wonder if 
someone has seen this before.

Just checking if someone has seen this issue before. (musing as to what 
the ideal style of __deprecated is)..

-- 
Regards,
Nishanth Menon

Ref:
[1] http://pastebin.mozilla.org/690162 (fail.patch)
[2] http://pastebin.mozilla.org/690160 (ok.patch)
	Usage in line 150
