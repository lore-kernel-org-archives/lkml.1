Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab0BJB4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 20:56:34 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:34418 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab0BJB4d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 20:56:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RCBuLE10x5WCTXP5L7fpCDnHW+oSp1S7BfowdPKzvpwdx0xiADgcp8D48y282uj5Pr
         4FxveIiCPcru0csdFJoKj9eNSfXbkw8Rjfoas1t+zid64sW2lga+mL1ammQ41hq8rZyM
         +Zwu0kwaDIBCihQ9cdHC+TxaUxPPSstIBaNaQ=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1002091716580.13999@chino.kir.corp.google.com>
References: <19314.1869.847327.15190@notabene.brown>
	 <alpine.DEB.2.00.1002091716580.13999@chino.kir.corp.google.com>
Date: Wed, 10 Feb 2010 09:56:31 +0800
Message-ID: <2375c9f91002091756h132e81eava8575ffd4e3ad421@mail.gmail.com>
Subject: Re: [PATCH] sysfs: differentiate between locking links and non-links
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Neil Brown <neilb@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 10, 2010 at 9:21 AM, David Rientjes <rientjes@google.com> wrote:
> On Wed, 10 Feb 2010, Neil Brown wrote:
>
>> commit 2e502cfe444b68f6ef6b8b2abe83b6112564095b
>> Author: NeilBrown <neilb@suse.de>
>> Date:   Wed Feb 10 09:43:45 2010 +1100
>>
>>     sysfs: differentiate  between locking links and non-links for sysfs
>>
>>     symlinks and non-symlink is sysfs are very different.
>>     A symlink can never be locked (active) while an attribute
>>     modification routine is running.  So removing symlink from an
>>     attribute 'store' routine should be permitted without any lockdep
>>     warnings.
>>
>>     So split the lockdep context for 's_active' in two, one for symlinks
>>     and other for everything else.
>>
>
> What happens for hard links such as writing to
> /sys/devices/block/xxx/queue/scheduler to change an I/O scheduler which
> requires sd->dep_map and sd->parent->dep_map in sysfs_get_active_two() to
> pin both?  The call to kobject_del() invokes the destruction that also
> requires sd->dep_map in sysfs_deactivate() because of the s_active lockdep
> annotation.
>

This is not related with Neil's case at all.

The I/O scheduler switch case should be a bogus, I am working on
it. We have more similar cases of cpu hotplug. Trust me, I am working
on a fix to all of them, this is not as easy as you may think about.

Thanks.
