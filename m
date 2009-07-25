Return-Path: <linux-kernel-owner+w=401wt.eu-S1752531AbZGYGwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbZGYGwe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 02:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbZGYGwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 02:52:33 -0400
Received: from mail-pz0-f192.google.com ([209.85.222.192]:56149 "EHLO
	mail-pz0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbZGYGwd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 02:52:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Hd4t7OxF+vG+lGEI9o9miWBL+3npT+xBi5RssIZLIzUsxI3AZoUM0lfyoXQQoj1G8w
         kAmGP0fD4/0srcxnabr2pAqYdemoOuTrkgqB7iFvRBHSPAQdKhadhKXev3tU4AYlSO4w
         2Z3oLjOrYiV5mr4kTJCoO2jMfXmGPpXV0Oxe8=
MIME-Version: 1.0
In-Reply-To: <7b6bb4a50907242334m15335df6xaa0a8f96fc6cfcd4@mail.gmail.com>
References: <1248419547-30261-1-git-send-email-dfeng@redhat.com>
	 <d82e647a0907242038l460c01b0ud51a7265f70d6c2e@mail.gmail.com>
	 <7b6bb4a50907242334m15335df6xaa0a8f96fc6cfcd4@mail.gmail.com>
Date: Sat, 25 Jul 2009 14:52:33 +0800
Message-ID: <d82e647a0907242352i5e184dd2i488ae6918e9cd959@mail.gmail.com>
Subject: Re: [PATCH] lib/kobject: put kobject if kobject_add_internal fails
From: Ming Lei <tom.leiming@gmail.com>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: Xiaotian Feng <dfeng@redhat.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/25 Xiaotian Feng <xtfeng@gmail.com>:
>> No, you should fix the 20+ files instead of lib/kobject. One rule should
>> be:
>>
>>             One who allocated kobject should free the kobject,
>> instead of others.
>
>
> kobject_put is not to free the kobject, it's to cleanup the resources
> allocated by kobject_init/add/....
> After kobject_put, we just have a cleanup kobject. The freed action is taken
> by kfree called by who uses kobject,

kobject_put may (but not must) free the kobject, which depends on the kobj_type
passed to  kobject_init_and_add. The .release of the default
kobj_type(dynamic_kobj_ktype) will free the kobject and kobject_put will call
.release.

Even you can make sure _all_ .release of the passed kobj_type does not free
the kobject, you still have the double calling of kobject_put problem,
don't you?

Thanks.

-- 
Lei Ming
