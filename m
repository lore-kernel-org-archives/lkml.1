Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883AbZDMQiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbZDMQiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 12:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbZDMQhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 12:37:51 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:46825 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbZDMQhu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 12:37:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xOc91p54xJPtGDXe5y842gACaMtOC76ketWylwjwzgVWbwTi7eUDKo99cAYVf1kP0T
         ei0J521PbQ6ZDwN7Z1AXgKqc/yRp6McnxRDRa70U3uRdS81ZGeNqhOTxH6iUrReZDkZw
         4UuT4b/G8BdGH48H4SSdB0HgoEdmvg2TKtsCg=
MIME-Version: 1.0
In-Reply-To: <20090413163101.GD32368@kroah.com>
References: <1239466586-29410-1-git-send-email-tom.leiming@gmail.com>
	 <20090413163101.GD32368@kroah.com>
Date: Mon, 13 Apr 2009 19:37:47 +0300
X-Google-Sender-Auth: 810de1bd55c29dbb
Message-ID: <84144f020904130937w4443ed2fjc5645824fd1377f@mail.gmail.com>
Subject: Re: [PATCH] kobject: kzfree object in _release function
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Greg KH <greg@kroah.com>
Cc: tom.leiming@gmail.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Mon, Apr 13, 2009 at 7:31 PM, Greg KH <greg@kroah.com> wrote:
> On Sun, Apr 12, 2009 at 12:16:26AM +0800, tom.leiming@gmail.com wrote:
>> From: Ming Lei <tom.leiming@gmail.com>
>>
>> It helps to troubleshoot the __buggy__ case, in which
>> unreferenced objects are still accessed, using kzfree
>> to free objects safely in _release function.
>>
>> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
>> ---
>>  lib/kobject.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/lib/kobject.c b/lib/kobject.c
>> index a6dec32..cb5a562 100644
>> --- a/lib/kobject.c
>> +++ b/lib/kobject.c
>> @@ -597,7 +597,7 @@ void kobject_put(struct kobject *kobj)
>>  static void dynamic_kobj_release(struct kobject *kobj)
>>  {
>>       pr_debug("kobject: (%p): %s\n", kobj, __func__);
>> -     kfree(kobj);
>> +     kzfree(kobj);
>>  }
>>
>>  static struct kobj_type dynamic_kobj_ktype = {
>> @@ -762,7 +762,7 @@ static void kset_release(struct kobject *kobj)
>>       struct kset *kset = container_of(kobj, struct kset, kobj);
>>       pr_debug("kobject: '%s' (%p): %s\n",
>>                kobject_name(kobj), kobj, __func__);
>> -     kfree(kset);
>> +     kzfree(kset);
>
>
> What about slab-poisoning?  Shouldn't we just rely on that instead?

Yes, you should. kzfree() strictly for cases where _correctness_ of
the program requires it (i.e. security concerns).
