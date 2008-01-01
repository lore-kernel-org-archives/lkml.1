Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbYAANo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbYAANo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 08:44:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbYAANow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 08:44:52 -0500
Received: from mx1.suse.de ([195.135.220.2]:45007 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315AbYAANov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 08:44:51 -0500
From: Andreas Schwab <schwab@suse.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-mips@linux-mips.org
Subject: Re: [Patch 2/8] MIPS: Remove 'TOPDIR' from Makefiles
References: <20080101071311.GA2496@hacking> <20080101072238.GC2496@hacking>
	<20080101101540.GB28913@uranus.ravnborg.org>
X-Yow: BI-BI-BI-BI-BI-BI-BI-BI-BI-BI-BI-BI-BI-BI-BI-BI-BI-BI-BI-BI-BI-BI-BI-BI-BI-BI-
Date: Tue, 01 Jan 2008 14:44:48 +0100
In-Reply-To: <20080101101540.GB28913@uranus.ravnborg.org> (Sam Ravnborg's
	message of "Tue\, 1 Jan 2008 11\:15\:40 +0100")
Message-ID: <jefxxhlkxb.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg <sam@ravnborg.org> writes:

>> @@ -24,7 +24,7 @@ HEAD_DEFINES := -D_kernel_start=0x$(KERNEL_START) \
>>  		-D TIMESTAMP=$(shell date +%s)
>>  
>>  $(obj)/head.o: $(obj)/head.S $(KERNEL_IMAGE)
>> -	$(CC) -fno-pic $(HEAD_DEFINES) -I$(TOPDIR)/include -c -o $@ $<
>> +	$(CC) -fno-pic $(HEAD_DEFINES) -I$(objtree)/include -c -o $@ $<
> This has never worked with O=.. builds.
> The correct fix here is to use:
>> +	$(CC) -fno-pic $(HEAD_DEFINES) -Iinclude -Iinclude2 -c -o $@ $<
>
> The -Iinclude2 is only for O=... builds so to keep current
> behaviour removing $(TOPDIR)/ would do it.

Shouldn't that use $(LINUXINCLUDE), or $(KBUILD_CPPFLAGS)?

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
