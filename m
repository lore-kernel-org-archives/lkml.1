Return-Path: <linux-kernel-owner+w=401wt.eu-S1755663AbZGURCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663AbZGURCD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 13:02:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbZGURCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 13:02:01 -0400
Received: from mail-qy0-f173.google.com ([209.85.221.173]:60409 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834AbZGURCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 13:02:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=CqBY8teADogmur+ZZGkSm97UauVf60QzcKVWolQR3DDI1/Xz0a+ijJwWWZj26/VgYE
         33UhS5Ggo+ZwTp3YZg1OhMy6Hr7VXhjqJSIZDHSuFeRoWXp3cQmC2C7ZBZoJs1QBV1yi
         na12eRvyVGr16AK70M0GS/qa0V3fB/50lZZOk=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0907211242570.11743@gandalf.stny.rr.com>
References: <cover.1248190728.git.jbaron@redhat.com> <42fb2af3afccef87d78ca6dd86169ad180b63271.1248190728.git.jbaron@redhat.com> 
	<2c0942db0907210926ra96ee33ke3e6ac8c57458be8@mail.gmail.com> 
	<alpine.DEB.2.00.0907211242570.11743@gandalf.stny.rr.com>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Tue, 21 Jul 2009 10:01:40 -0700
X-Google-Sender-Auth: 0e1689643e2496ed
Message-ID: <2c0942db0907211001o5273a3ccybbba4de448150ddf@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf_counter: detect debugfs location
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, paulus@samba.org, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 9:44 AM, Steven Rostedt<rostedt@goodmis.org> wrote:
>
> On Tue, 21 Jul 2009, Ray Lee wrote:
>
>> On Tue, Jul 21, 2009 at 9:20 AM, Jason Baron <jbaron@redhat.com> wrote:
>> >
>> > Search for the debugfs filesystem in /proc/mounts, but also allows the user to
>> > specify '--debugfs-dir=blah' or set the environment variable: 'PERF_DIR_DEBUGFS'
>>
>> > -static char default_debugfs_path[] = "/sys/kernel/debug/tracing/events";
>>
>> There are server systems out there that run with thousands of mounts.
>> It would be kinder to the users of those systems (ie, faster perf
>> startup) if you only went rooting around /proc/mounts if opening the
>> default location failed.
>
> Well, those that have thousand of mounts could probably get away with
> setting PERF_DIR_DEBUGFS in /etc/profile.

The intent of the patch is obviously to try to Do The Right Thing by
default. I think that's great. I just think it should DT(fast and)RT
instead.

> But, a simple stat("/sys/kernel/debug/tracing") should be easy enough.

<nod>
