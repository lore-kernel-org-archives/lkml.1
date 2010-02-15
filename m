Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab0BOJ0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 04:26:24 -0500
Received: from mail-pz0-f197.google.com ([209.85.222.197]:39289 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab0BOJ0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 04:26:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=E2UjU85msjBj4mYN4YiD57bBxGHqGDMrBcFHRvKIEIpXe1MZAQgr4tt5Je5RySPBaK
         ElJ7C7VbHDF1dzcG2vulRjDo1gSzdzixVa3OBpl9JE55/SPmepEdJzIgiWzRuT/grXh8
         CqaZP594tBIwKsJu0r+Xk6ZPVuEozg6SNU5I4=
Date: Mon, 15 Feb 2010 16:31:20 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "Tejun Heo <tj@kernel.org> Neil Brown" <neilb@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] sysfs: Only take active references on attributes.
Message-ID: <20100215083120.GE12076@hack.private>
References: <4B728CFE.40208@kernel.org> <m1sk992bji.fsf@fess.ebiederm.org> <20100210230544.GA678@suse.de> <m1ocjwwob1.fsf@fess.ebiederm.org> <4B73671E.2050105@kernel.org> <m1bpfvxt67.fsf_-_@fess.ebiederm.org> <m14olnxt3s.fsf_-_@fess.ebiederm.org> <m1ljezwean.fsf_-_@fess.ebiederm.org> <20100215072745.GC12076@hack.private> <20100215081527.GD12076@hack.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100215081527.GD12076@hack.private>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 04:15:27PM +0800, Américo Wang wrote:
>On Mon, Feb 15, 2010 at 03:27:45PM +0800, Américo Wang wrote:
>>On Thu, Feb 11, 2010 at 03:20:00PM -0800, Eric W. Biederman wrote:
>>>
>>>If we exclude directories and symlinks from the set of sysfs
>>>dirents where we need active references we are left with
>>>sysfs attributes (binary or not).
>>>
>>>- Tweak sysfs_deactivate to only do something on attributes
>>>- Move lockdep initialization into sysfs_file_add_mode to
>>>  limit it to just attributes.
>>
>>Why?
>>
>>If I read your patch correctly, s_active will be useless
>>for non-attributes sysfs entries? For sysfs dir, maybe,
>>since it can only be removed by sysfs_remove_dir(),
>>but not sure about sysfs symlinks...
>>
>
>For sysfs dir's, opening it will not get s_active,
>since it doesn't have .open member. But it does
>put s_active when removing it. This seems buggy?

Oh, definitely no...

s_active of sysfs dir is only for kernel space,
after your previous patch.

>
>For symlinks, it seems sysfs totally ignores s_active,
>thus is safe for this patch.
>

Thus, your patch seems correct.

I think we could merge them for more testing.

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks!
