Return-Path: <linux-kernel-owner+w=401wt.eu-S1755672AbZF1Tb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbZF1Tb6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 15:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbZF1Tbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 15:31:51 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:42249 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbZF1Tbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 15:31:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Z1MRIEkeFNpPp3K38ogB9DJF1RROLRZZhVNjNg6+/qPsJawJMD37xVcyGpg0bOHmxc
         a3SwfqzYG2N0If/0dnrvqSxaRnbrZ6yByv+49w2j1AddzSerym7hsRlveTu1LZgVL1lx
         96iUQ6PD9SXeWKSTLsuM+dL4zEufVVI/jBX3I=
MIME-Version: 1.0
In-Reply-To: <1158166a0906261555k3f00e9bdi74960e9eb72a4bb7@mail.gmail.com>
References: <1158166a0906241600w5f7f4ffcm49d9c849f0c27f72@mail.gmail.com> 
	<20090625091002.0b8203a7@lxorguk.ukuu.org.uk> <1158166a0906260100q79475523l546cddde2c0ca03@mail.gmail.com> 
	<8bd0f97a0906260626y36190ca9ia769c623d4c545d3@mail.gmail.com> 
	<1158166a0906261555k3f00e9bdi74960e9eb72a4bb7@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 28 Jun 2009 15:31:32 -0400
Message-ID: <8bd0f97a0906281231m53f6653au96bc7da0ad054eac@mail.gmail.com>
Subject: Re: [PATCH] allow execve'ing "/proc/self/exe" even if /proc is not 
	mounted
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 18:55, Denys Vlasenko wrote:
> On Fri, Jun 26, 2009 at 3:26 PM, Mike Frysinger wrote:
>> On Fri, Jun 26, 2009 at 04:00, Denys Vlasenko wrote:
>>> On Thu, Jun 25, 2009 at 10:10 AM, Alan Cox wrote:
>>>>> With this patch, it is possible to execute /proc/self/exe
>>>>> even if /proc is not mounted. In the below example,
>>>>> ./sh is a static shell binary:
>>>>
>>>> What if the user has procfs mounted somewherelse, what if they are in a
>>>> chroot where you don't want them to patch the binary and re-exec it ?
>>>>
>>>> It would be far far cleaner for NOMMU to have a NOMMU private "reexec()"
>>>> call that didn't rely on procfs or hacking names into the kernel.
>>>>
>>>> So NAK
>>>
>>> I am ok with it. Are other people ok with adding a syscall
>>> just for this purpose? Al?
>>
>> please try a custom binfmt first
>
> I did not understand you.

i was thinking fs/binfmt_*.c will get executed all the time, but they
may not get the chance if execve() aborts early due to the file not
being found.  if that's the case, then nm me.
-mike
