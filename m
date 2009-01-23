Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbZAWRYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbZAWRYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 12:24:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbZAWRY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 12:24:27 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:40534 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbZAWRY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 12:24:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kVmkmg0gAfPks8o3LAax32yk/ODWn5kN6Tii02hc1IXjMwIOwUev6gIhODGoyPQq6I
         oLMB+95wwAZwEfZ8gmIoC5mhROyA/A0TpKLpIfsI8UEb9f1PVbOvtA4jc0MZEgzVXoM0
         cViCX39P4qHwgvhXevYvQyVtWBbh9OsWITpaQ=
MIME-Version: 1.0
In-Reply-To: <20090123170631.GB11566@suse.de>
References: <20081203193901.715896543@mini.kroah.org>
	 <20081203194849.GQ8950@kroah.com>
	 <1232686261.9977.1296303473@webmail.messagingengine.com>
	 <20090123051620.GA8122@suse.de>
	 <1232704065.25510.1296328851@webmail.messagingengine.com>
	 <20090123170631.GB11566@suse.de>
Date: Fri, 23 Jan 2009 18:24:24 +0100
Message-ID: <195c7a900901230924n13ed225dq4aeff8015d22588e@mail.gmail.com>
Subject: Re: [patch 016/104] epoll: introduce resource usage limits
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2009 at 6:06 PM, Greg KH <gregkh@suse.de> wrote:
> On Fri, Jan 23, 2009 at 08:47:45PM +1100, Bron Gondwana wrote:
>> On Thu, 22 Jan 2009 21:16 -0800, "Greg KH" <gregkh@suse.de> wrote:
>> > > This is a kvm virtual machine running on a reasonably beefy external box, but
>> > > with 2Gb RAM allocated to the mx instance because that's all kvm would let me
>> > > use last time I checked.  We're using KVM so the local copy of the database is
>> > > a little further away from the "internet facing side" and so we can build each
>> > > machine with our standard FAI setup.
>> >
>> > I would suggest just changing this default value then, it's a simple
>> > userspace configuration item, and for your boxes, it sounds like a
>> > larger value would be more suitable.
>>
>> Yes - I've pushed it up to 4096 now.  Should be plenty!
>>
>> I guess Postfix is a bit of an odd case here.   It runs lots of processes, yet
>> uses epoll within many of them as well - sort of a historical design in some ways,
>> but also to enforce maximum privilege separation with many of the daemons able to
>> be run under chroot with limited capabilities.
>>
>> So I guess I have a few questions left:
>>
>> 1) is this value ever supposed to be hit in practice by non-malicious software?
>>    If not, it appears 128 is too low.
>
> It does appear a bit low.  What looks to you like a good value to use as
> a default?
>
>> 2) if we're going to stick with 128, is there any way to query the kernel as to how
>>    close to the limit it's getting?  As an example, our system checks poll
>>    /proc/sys/fs/file-max every 2 minutes, and warn us if its getting "full".
>
> Good idea, we should report this somewhere for the very reasons you
> suggest.  Can you write up a patch to do this?  If not, I'll see what I
> can do.

Why not using a ulimit for this kind of stuff ?

Regards

Bastien
