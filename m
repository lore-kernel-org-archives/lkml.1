Return-Path: <linux-kernel-owner+w=401wt.eu-S1751875AbYKSB0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbYKSB0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 20:26:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbYKSBZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 20:25:55 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:54337 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbYKSBZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 20:25:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kYcnDStDTFf6YsMWwoKBRun1sWOBv7QQ5BK8AsimYcTxo3qNMjnN8aInvimEH8GiJo
         WIYcYzYyN4pMNF8cSh3jaadCRDecOq4jH/J2CGw74EzyoYOPAZOMDTcPFOcr6aiLK9xi
         3CUAirDFrIXp18RzRyn5wpeIENUsh2AzXyTxY=
Message-ID: <d82e647a0811181725y3a01f9aanca4cf3ca7e8f3081@mail.gmail.com>
Date: Wed, 19 Nov 2008 09:25:53 +0800
From: "Ming Lei" <tom.leiming@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel/ksysfs.c:fix dependence on CONFIG_NET
Cc: kay.sievers@vrfy.org, greg@kroah.com, linux-kernel@vger.kernel.org
In-Reply-To: <20081118154128.56d1d3ca.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226830929-6610-1-git-send-email-tom.leiming@gmail.com>
	 <20081118153818.e623ba03.akpm@linux-foundation.org>
	 <20081118154128.56d1d3ca.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/19 Andrew Morton <akpm@linux-foundation.org>:
> On Tue, 18 Nov 2008 15:38:18 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> On Sun, 16 Nov 2008 18:22:09 +0800
>> tom.leiming@gmail.com wrote:
>>
>> > From: Ming Lei <tom.leiming@gmail.com>
>> >
>> > Access to uevent_seqnum and uevent_helper does not need to
>> > depend on CONFIG_NET, so remove it.
>> >
>> > Signed-off-by: Ming Lei <tom.leiming@gmail.com>
>> > ---
>> >  kernel/ksysfs.c |    4 ++--
>> >  1 files changed, 2 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
>> > index 08dd8ed..528dd78 100644
>> > --- a/kernel/ksysfs.c
>> > +++ b/kernel/ksysfs.c
>> > @@ -24,7 +24,7 @@ static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
>> >  static struct kobj_attribute _name##_attr = \
>> >     __ATTR(_name, 0644, _name##_show, _name##_store)
>> >
>> > -#if defined(CONFIG_HOTPLUG) && defined(CONFIG_NET)
>> > +#if defined(CONFIG_HOTPLUG)
>> >  /* current uevent sequence number */
>> >  static ssize_t uevent_seqnum_show(struct kobject *kobj,
>> >                               struct kobj_attribute *attr, char *buf)
>> > @@ -137,7 +137,7 @@ struct kobject *kernel_kobj;
>> >  EXPORT_SYMBOL_GPL(kernel_kobj);
>> >
>> >  static struct attribute * kernel_attrs[] = {
>> > -#if defined(CONFIG_HOTPLUG) && defined(CONFIG_NET)
>> > +#if defined(CONFIG_HOTPLUG)
>> >     &uevent_seqnum_attr.attr,
>> >     &uevent_helper_attr.attr,
>> >  #endif
>>
>> I think the story here is that uevent uses netlink, and with
>> CONFIG_NET=n, we have no netlink, so that code couldn't do anything
>> anyway.
>>
>
> Or not.  Perhaps we can still use uevent_helper in this case?

yes.


>
> (Getting a bit tired of writing people's changelogs for them!)
>



-- 
Lei Ming
