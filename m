Return-Path: <linux-kernel-owner+w=401wt.eu-S1758502AbYELGlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758502AbYELGlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 02:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754738AbYELGlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 02:41:11 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:47117 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581AbYELGlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 02:41:10 -0400
Message-ID: <4827E67E.3050008@krogh.cc>
Date: Mon, 12 May 2008 08:41:02 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org
Subject: Re: Many open/close on same files yeilds "No such file or directory".
References: <4819E316.7000607@krogh.cc>	<4823DFA6.9010504@krogh.cc>	<20080508223635.523b8fa7.akpm@linux-foundation.org>	<4823EA9E.6050703@krogh.cc> <18471.41781.164396.385159@notabene.brown>
In-Reply-To: <18471.41781.164396.385159@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:
> On Friday May 9, jesper@krogh.cc wrote:
>> When I disabled the NFS-server and rand my "real-world" program on a
>> single processor (make -j 1). It ran through fine. It basically
>> gets around 20 million chunks out of differnet file and assemble the
>> chuncks in a few other files. This processes more or less 5 individual
>> sections, so make can run effectively with a concurrency of 5.
> 
> (For linux-nfs readers: the problem is that repeatedly opening a given
>  file sometimes returns a ENOENT - http://lkml.org/lkml/2008/5/9/15).

This thing really, really irritated me, but I must admit that Andrew 
Morton was very correct about this "not being very likely"- a kernel
bug.

It seem that our central configuration handling system (slack) was being
way to aggressive about updating symlinks in paths of the filesystems
that I was testing upon, that explains why I couldn't reproduce it
on the internal volumes, and not on any of the volumes I created only
for testing purposes. Sometimes you just get too blind..
(I haven't been able to reproduce for 12 hours now)

Just to answer your questions, yes, the 48 clients do hammer on NFS and
now it seems to work excellent.

Sorry for all the noise.

-- 
Jesper
