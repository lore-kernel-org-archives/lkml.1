Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbYEKKJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbYEKKJT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 06:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbYEKKJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 06:09:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53177 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbYEKKJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 06:09:08 -0400
Message-ID: <4826C5BC.6060203@firstfloor.org>
Date: Sun, 11 May 2008 12:09:00 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Disable modpost warnings for linkonce sections
References: <20080508114111.GA20671@basil.nowhere.org> <20080511081156.GA25696@uranus.ravnborg.org>
In-Reply-To: <20080511081156.GA25696@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Thu, May 08, 2008 at 01:41:11PM +0200, Andi Kleen wrote:
>> Disable modpost warnings for linkonce sections
>>
>> My build gives lots of warnings like
>>
>> WARNING: sound/core/snd.o (.gnu.linkonce.wi.mpspec_def.h.30779716): unexpected section name.
>> The (.[number]+) following section name are ld generated and not expected.
>> Did you forget to use "ax"/"aw" in a .S file?
>> Note that for example <linux/init.h> contains
>> section definitions for use in .S files.
>>
>> But for .linkonce. duplicated sections are actually ok and expected.
>> So just disable the warning for this case.
> 
> Agreed.
> Applied and pushed out.

There's still the "crap in /proc/kallsyms" problem like

0000000000000b0c N DW.aio.h.903a6d92.0
0000000000000b19 N DW.aio.h.903a6d92.1
0000000000000b24 N DW.aio.h.903a6d92.2
0000000000000bce N DW.task_io_accounting.h.8d8de327.0

Haven't not looked at that yet, but that needs to be fixed too.

-Andi
