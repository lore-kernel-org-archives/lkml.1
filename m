Return-Path: <linux-kernel-owner+w=401wt.eu-S1753057AbXLEHd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbXLEHd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 02:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbXLEHdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 02:33:49 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:6444 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbXLEHds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 02:33:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=EbigcmSX2PVm7bYYf5rkYpeqU7xXTQnWrxyfX0vv46F9pF78weSvAdNJtXLLePQ4BV1AHvbubDAa3rLALaUtAVOtkp/vBRWe+/5SdEKaFkMi1O6YCOp53bmdFsshBdgdzDtusV2+Wm93K9FJ5NqWKe2L1aapdZs4iriZZ3tu3bo=
Message-ID: <47565452.3010800@gmail.com>
Date: Wed, 05 Dec 2007 16:33:38 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, notting@redhat.com,
       rusty@rustcorp.com.au, kay.sievers@vrfy.org, greg@kroah.com
Subject: Re: [PATCH] depmod: sort output according to modules.order
References: <47555AF1.8090304@gmail.com> <47555C64.8070607@gmail.com> <20071205072529.GA5681@uranus.ravnborg.org>
In-Reply-To: <20071205072529.GA5681@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> Hi Tejun.
> On Tue, Dec 04, 2007 at 10:55:48PM +0900, Tejun Heo wrote:
>> Kbuild now generates and installs modules.order along with modules.
>> This patch updates depmod such that it sorts module list according to
>> the file before generating output files.  Modules which aren't on
>> modules.order are put after modules which are ordered by
>> modules.order.
>>
>> This makes modprobe to prioritize modules according to kernel
>> Makefile's just as built-in modules are link-ordered by them.
> 
> With this change depmod require the precense of modules.order.
> Could we make it optional so depmod are backward compatible?

It is backward compatible by virtue of

+		if (errno == ENOENT)
+			return;

in sort_modules().  If the file isn't there, the list isn't sorted.

> It would also simplify the kbuild integration if depmod
> could read the modules as a space separated list where
> duplicates are allowed.
> If we do so then the is no reason to escape to the shell
> in Makeilfe.build and we do not have to remove duplicates either.

I'm no Makefile expert so no doubt my modifications are ugly.  But I
think producing a file w/ duplicates in it is just ugly.

-- 
tejun
