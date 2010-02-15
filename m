Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab0BOIM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 03:12:56 -0500
Received: from mail-px0-f191.google.com ([209.85.216.191]:46489 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab0BOIMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 03:12:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Q2SGG+yhyBcoseD30szwhVIsUx6ehVHyG2kPEAk1F0EH1deexvjeT2MqdhRMBcG+NE
         x1bSCpqeroFnGdJ5fofkbUp4tb9AtgEacGEQfrFH1nHXCLVa6num8Zr492UTBqwXZ7wD
         9H9deDITqwdw8esa5HqfXG+/jcYZLKCMaIxR0=
Date: Mon, 15 Feb 2010 16:15:27 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "Tejun Heo <tj@kernel.org> Neil Brown" <neilb@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] sysfs: Only take active references on attributes.
Message-ID: <20100215081527.GD12076@hack.private>
References: <m1vde57c11.fsf@fess.ebiederm.org> <4B728CFE.40208@kernel.org> <m1sk992bji.fsf@fess.ebiederm.org> <20100210230544.GA678@suse.de> <m1ocjwwob1.fsf@fess.ebiederm.org> <4B73671E.2050105@kernel.org> <m1bpfvxt67.fsf_-_@fess.ebiederm.org> <m14olnxt3s.fsf_-_@fess.ebiederm.org> <m1ljezwean.fsf_-_@fess.ebiederm.org> <20100215072745.GC12076@hack.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100215072745.GC12076@hack.private>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 03:27:45PM +0800, Américo Wang wrote:
>On Thu, Feb 11, 2010 at 03:20:00PM -0800, Eric W. Biederman wrote:
>>
>>If we exclude directories and symlinks from the set of sysfs
>>dirents where we need active references we are left with
>>sysfs attributes (binary or not).
>>
>>- Tweak sysfs_deactivate to only do something on attributes
>>- Move lockdep initialization into sysfs_file_add_mode to
>>  limit it to just attributes.
>
>Why?
>
>If I read your patch correctly, s_active will be useless
>for non-attributes sysfs entries? For sysfs dir, maybe,
>since it can only be removed by sysfs_remove_dir(),
>but not sure about sysfs symlinks...
>

For sysfs dir's, opening it will not get s_active,
since it doesn't have .open member. But it does
put s_active when removing it. This seems buggy?

For symlinks, it seems sysfs totally ignores s_active,
thus is safe for this patch.

