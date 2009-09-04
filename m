Return-Path: <linux-kernel-owner+w=401wt.eu-S933706AbZIDQ45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933706AbZIDQ45 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932871AbZIDQ4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:56:54 -0400
Received: from claw.goop.org ([74.207.240.146]:50953 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932870AbZIDQ4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:56:54 -0400
Message-ID: <4AA146D6.8030802@goop.org>
Date: Fri, 04 Sep 2009 09:56:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Bastian Blank <waldi@debian.org>, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, 544145@bugs.debian.org,
       Keir Fraser <keir.fraser@eu.citrix.com>
Subject: Re: 32bit binaries on x86_64/Xen segfaults in syscall-vdso
References: <20090830181637.GA7155@wavehammer.waldi.eu.org> <4AA02C57.30106@goop.org> <20090903220252.GA19309@wavehammer.waldi.eu.org> <4AA03DE8.40706@goop.org> <20090903223603.GA19945@wavehammer.waldi.eu.org> <4AA13B4B.7020101@goop.org> <20090904162003.GA6147@wavehammer.waldi.eu.org>
In-Reply-To: <20090904162003.GA6147@wavehammer.waldi.eu.org>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/09 09:20, Bastian Blank wrote:
> On Fri, Sep 04, 2009 at 09:07:39AM -0700, Jeremy Fitzhardinge wrote:
>   
>> But for some reason that's triggering a failsafe callback, which invokes
>> a GP.
>>     
> Hmm, not in my tests. It always returned to userspace correctly and died
> some operations later, usually the "ret". This then produced either a
> segfault (unreadable address), sigill (if it managed to reach the ELF
> header of the ld.so) or a GPF.

Hm, I may have misdiagnosed it then.  Your symptoms are odd; either its
landing back in userspace in the right place but then stumbles on for a
while before crashing (wrong processor mode?) or the eip is wrong and
its just landing in the wrong place and crashing immediately. 

How non-deterministic is it?  Does it differ every time, or from boot to
boot, build to build?

    J

