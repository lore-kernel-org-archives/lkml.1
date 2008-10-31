Return-Path: <linux-kernel-owner+w=401wt.eu-S1752611AbYJaR6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbYJaR6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 13:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYJaR6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 13:58:09 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:6585 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbYJaR6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 13:58:08 -0400
Message-ID: <ac3eb2510810311057j6069aa99j4f46c6f563b5740@mail.gmail.com>
Date: Fri, 31 Oct 2008 18:57:52 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Greg KH" <greg@kroah.com>
Subject: Re: driver core: struct device - replace bus_id with dev_name(), dev_set_name()
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20081031170227.GC24826@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225327008.5970.27.camel@nga.site>
	 <20081031170227.GC24826@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 18:02, Greg KH <greg@kroah.com> wrote:
> On Thu, Oct 30, 2008 at 01:36:48AM +0100, Kay Sievers wrote: index 5437ac0..c9c214d 100644
>> --- a/include/linux/kobject.h
>> +++ b/include/linux/kobject.h
>> @@ -72,6 +72,8 @@ struct kobject {
>>
>>  extern int kobject_set_name(struct kobject *kobj, const char *name, ...)
>>                           __attribute__((format(printf, 2, 3)));
>> +extern int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
>> +                               va_list vargs);
>>
>>  static inline const char *kobject_name(const struct kobject *kobj)
>>  {
>> diff --git a/lib/kobject.c b/lib/kobject.c
>> index 0487d1f..a6dec32 100644
>> --- a/lib/kobject.c
>> +++ b/lib/kobject.c
>> @@ -212,7 +212,7 @@ static int kobject_add_internal(struct kobject *kobj)
>>   * @fmt: format string used to build the name
>>   * @vargs: vargs to format the string.
>>   */
>> -static int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
>> +int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
>>                                 va_list vargs)
>>  {
>>       const char *old_name = kobj->name;
>>
>
> I cut this part out of this patch, as it's not needed here, and applied
> the rest.

Ah, yeah, this hunk belongs to "driver core: get rid of bus_id" which
I sent you, and which should be locally in your tree to catch new
instances of bus_id in staging. We will push to -next when we got most
of it converted and want to fix the remaining pieces.

Kay
