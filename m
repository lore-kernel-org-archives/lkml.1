Return-Path: <linux-kernel-owner+w=401wt.eu-S1757857AbZAXIgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbZAXIgf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 03:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbZAXIg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 03:36:27 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:14495 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbZAXIg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 03:36:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=B68nDgtD95YD+Q8g1Oo9IgTWQImVMa/ryKvtR4W6N1zO8c3XaRBCXrrdLUEDRLyOJF
         Q2b6FWd1ALLsghtKXHVrYFKDMWwDbXgj+02cmD0lGoyR+ZDfAwph2AEsVuiYvnDkFKRb
         GT31pSjSHvhsj+r1qN3mEhWG5hJxZVIOS9d5E=
MIME-Version: 1.0
In-Reply-To: <20090124035006.GA8051@brong.net>
References: <20081203193901.715896543@mini.kroah.org>
	 <20081203194849.GQ8950@kroah.com>
	 <1232686261.9977.1296303473@webmail.messagingengine.com>
	 <20090123051620.GA8122@suse.de>
	 <1232704065.25510.1296328851@webmail.messagingengine.com>
	 <20090123170631.GB11566@suse.de> <20090124035006.GA8051@brong.net>
Date: Sat, 24 Jan 2009 09:36:22 +0100
Message-ID: <19f34abd0901240036pbcd9323pa62af60276cd25bb@mail.gmail.com>
Subject: Re: [patch 016/104] epoll: introduce resource usage limits
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Bron Gondwana <brong@fastmail.fm>
Cc: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 24, 2009 at 4:50 AM, Bron Gondwana <brong@fastmail.fm> wrote:
> On Fri, Jan 23, 2009 at 09:06:31AM -0800, Greg KH wrote:
>> On Fri, Jan 23, 2009 at 08:47:45PM +1100, Bron Gondwana wrote:
>> > On Thu, 22 Jan 2009 21:16 -0800, "Greg KH" <gregkh@suse.de> wrote:
>> > >
>> > > I would suggest just changing this default value then, it's a simple
>> > > userspace configuration item, and for your boxes, it sounds like a
>> > > larger value would be more suitable.
>
> If everyone, or every distribution at least, has to change it then the
> default is probably wrong.  The error message in the postfix logs didn't
> immediately point me at the issue, especially since I tried debugging on
> one of our "production" mxes, only to discover that the epoll limit
> didn't exist there.  They're slightly behind in kernel versions.
>
>> > I guess Postfix is a bit of an odd case here.   It runs lots of
>> > processes, yet uses epoll within many of them as well - sort of
>> > a historical design in some ways, but also to enforce maximum
>> > privilege separation with many of the daemons able to
>> > be run under chroot with limited capabilities.
>> >
>> > So I guess I have a few questions left:
>> >
>> > 1) is this value ever supposed to be hit in practice by
>> >    non-malicious software? If not, it appears 128 is too low.
>>
>> It does appear a bit low.  What looks to you like a good value to use as
>> a default?
>
> This thread suggests that it's not just postfix having the issue, and
> offers 1024 as a saner default:
>
> http://www.mail-archive.com/fedora-kernel-list@redhat.com/msg01618.html
>
> There's also a Russian thread that pointed me at this patch in the first
> place, and another place that suggested 1024 as well.  Seems "the
> cloud"[tm] is converging on 1024.

With the default limit of 128 (max_user_instances) and 274274
(max_user_watches) on my machine, the maximum amount of memory
consumed by one user's epoll instances is barely noticable (around
1.5M).

Raising the max_user_instances to 512 brings us up to a maximum memory
usage of 43M already. However, from here on, we are already getting
limited by the number of user watches.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
