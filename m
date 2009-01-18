Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbZASAAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbZASAAo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 19:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbZASAAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 19:00:24 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:50550 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbZASAAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 19:00:22 -0500
Message-ID: <4973C26F.70400@oracle.com>
Date: Sun, 18 Jan 2009 15:59:43 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Simon W Bock <sbock@uni-tuebingen.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: KALLSYMS always enabled in 'make gconfig' on PS3 kernel
References: <4972C77B.1070800@uni-tuebingen.de>
In-Reply-To: <4972C77B.1070800@uni-tuebingen.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4973C271.01E9:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon W Bock wrote:
> Hi All,
> this seems to be the most appropriate place to report it...

Yes, or linux-kbuild@vger.kernel.org

> I try to compile a kernel on and for the PS3 using Geoff Levand's
> sources
> http://git.kernel.org/?p=linux/kernel/git/geoff/ps3-linux.git;a=summary
> and did a 'make ps3_defconfig' before doing 'make gconfig'.
> Now I'd care much more for 300k less in kernel size than for full
> symbols in the OOPS, so I would like to deselect KALLSYMS and
> KALLSYMS_ALL. The latter is even suggested to disable in the help text.
> But whatever I do, those two are always selected. Even when I deselect
> them using vi, the next time I do a 'make gconfig' on the config-file
> they are on again.

First, this isn't gconfig-specific.  xconfig or menuconfig should
have the same behavior.  At least I see it in xconfig also.

> Is this done for some special reason? Or can they be turned off?

All 3 of the KALLSYMS kconfig symbols are under the kconfig menu
prompt:  "Configure standard kernel features (for small systems)",
which is not enabled in ps3_defconfig AFAICT (unless Geoff's is
modified from that I can see/test in linux-next).  All that you
need to do is enable that config symbol (called CONFIG_EMBEDDED)
and then you can modify the KALLSYMS config symbols.

HTH.
-- 
~Randy
