Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbZC1TTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbZC1TTM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 15:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbZC1TS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 15:18:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35032 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbZC1TS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 15:18:56 -0400
Message-ID: <49CE77F7.8020509@zytor.com>
Date: Sat, 28 Mar 2009 12:18:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Michael K. Johnson" <johnsonm@rpath.com>, jmforbes@linuxtx.org,
       Jordan_Hargrave@Dell.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mark %esi as clobbered in E820 BIOS call
References: <20090327171441.GD4363@logo.rdu.rpath.com> <20090328112035.GA11146@elte.hu>
In-Reply-To: <20090328112035.GA11146@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Michael K. Johnson <johnsonm@rpath.com> wrote:
> 
>> Justin and Peter, please review this for stable .y trees.  Peter,
>> please review this for trunk unless you decide to do a more 
>> extensive workaround for BIOS register clobbering.
>>
>> Thanks!
>>
>> $ cat e820-esi-clobber-workaround.patch
>> Jordan Hargrave diagnosed a BIOS clobbering %esi in the E820 call.
>> That particular BIOS has been fixed, but there is a possibility that
>> this is responsible for other occasional reports of early boot
>> failure, and it does not hurt to add %esi to the clobbers.
> 
> nice fix! Would you mind to update the clobber list to include _all_ 
> registers? I dont see why any of the other registers couldnt be 
> clobbered by a BIOS, and this is boot-only code so micro-performance 
> is not an issue.

%esi and %ebp are the only registers that aren't already clobbered.  gcc
doesn't like %ebp clobbers, so it has to be done via push..pop.  I have
been thinking about doing a generic register-save wrapper for *all* BIOS
calls; this plus the recent patch to do a bunch of similar hacks for
VESA calls kind of tells me it's time to do this.  However, I'm going to
clean up this for the trunk and Cc: stable for now.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

