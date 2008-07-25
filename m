Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbYGYNdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbYGYNdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 09:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbYGYNdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 09:33:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:9538 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbYGYNdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 09:33:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xHS5UBCINVQWl9W/9z/LmrBjEpYZeSTXJMWGUEapCwulT3CPqxSX9Xg1le83OAXIN3
         oSujdfnJEXz5lDRlfaASCFeAEOFzzKHSDVH3aLMMSrNITyy6J37tBDq/6ZV8e1+0rfMW
         uzkHLLPBnaeVW1wP4Lp2S+EbxlO7GJ0hMhFws=
Message-ID: <728201270807250633vcaf8ac2r3be1d37736283385@mail.gmail.com>
Date: Fri, 25 Jul 2008 08:33:10 -0500
From: "Ram Gupta" <ram.gupta5@gmail.com>
To: "Paul Menage" <menage@google.com>
Subject: Re: [RFC][PATCH][0/3] introduce rlimit cgroup
Cc: "Hirofumi Nakagawa" <hnakagawa@miraclelinux.com>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <6599ad830807242305w2895905dgcd91fe3a430806dc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <488722DF.9080003@miraclelinux.com>
	 <20080724150557.8697.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <48885A7F.80106@miraclelinux.com>
	 <6599ad830807242305w2895905dgcd91fe3a430806dc@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I understand that there might be some cases where it is useful to
allow some process to set rlimits of other processes (e.g. some
launcher process might want to control resources of all the
applications being launched by it). But this has to be a very special
case or this process needs to have special permission to do that
otherwise there will be a lot of problems as a side effect.

Ram

On Fri, Jul 25, 2008 at 1:05 AM, Paul Menage <menage@google.com> wrote:
>>
>> To set rlimit from other processes is my original intention.
>> For I do not see a way to do it, please let me know if there were any
>> exists.
>
> No, there's no way to do that currently. I'm not sure if it's
> generally safe to update the rlimit for another process.
>
> If we're trying to use rlimits in a cgroup context then some rlimits
> (e.g. max nice priority) ought to apply as additional caps on the
> processes in the cgroup (e.g. if you set a max nice priority of 1 on a
> cgroup, that ought to override any per-process settings) whereas
> others (e.g. locked memory, open files, num processes) ought to apply
> as an aggregate limit on the cgroup (so the sum of all open files
> across the cgroup shouldn't be able to exceed the cgroup's "open
> files" limit). E.g. see Balbir's memrlimit control groups patches that
> are currently in -mm.
>
> What concrete problem are you trying to solve here?
>
> Paul
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
