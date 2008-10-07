Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938AbYJGKfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbYJGKfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 06:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbYJGKfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 06:35:23 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:61652 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbYJGKfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 06:35:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=QQy9mdWzQI+irNgrCRaC+YyAI2CWVK/lodakC6+0ulj0LeffpxMOijBYnryxukP252
         NHm170hRr2DBlsHCewnQSTH/9TCzBCRF8BOYVaMLN9xu8N803K7h8v+3kb/gU21RVCz2
         ETZ4rcQCLo97iKL6ynkL2oo1eCxcS+enM/iLk=
Message-ID: <48EB3B58.9010106@gmail.com>
Date: Tue, 07 Oct 2008 12:35:04 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Michael Rubin <mrubin@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, dradford@bluehost.com,
       m.innocenti@cineca.it, fernando@oss.ntt.co.jp,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       chlunde@ping.uio.no, dave@linux.vnet.ibm.com, dpshah@google.com,
       agk@sourceware.org, matt@bluehost.com, menage@google.com,
       eric.rannaud@gmail.com, balbir@linux.vnet.ibm.com
Subject: Re: [RFC] [PATCH -mm 0/2] memcg: per cgroup dirty_ratio
References: <20080912131816.e0cfac7a.akpm@linux-foundation.org> <532480950809221641y3471267esff82a14be8056586@mail.gmail.com> <20080924024437.DC21.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080924024437.DC21.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>> Currently the problem we are hitting is that we cannot specify pdflush
>> to have background limits less than 1% of memory. I am currently
>> finishing up a patch right now that adds a dirty_ratio_millis
>> interface.  I hope to submit the patch to LKML by the end of the week.
>>
>> The idea is that we don't want to break backwards compatibility and we
>> also don't want to have two conflicting knobs in the sysctl or
>> /proc/sys/vm/ space. I thought adding a new knob for those who want to
>> specify finer grained functionality was a compromise. So the patch has
>> a vm_dirty_ratio and a vm_dirty_ratio_millis interface. The first to
>> specify 0-100% and the second to specify .0 to .999%.
>>
>> So to represent 0.125% of RAM we set
>> vm_dirty_ratio = 0
>> vm_dirty_ratio_millis = 125
>>
>> The same for the background_ratio.
> 
> Why vm_dirty_ratio = 0.125 is wrong?
> it is hardly for parser maker, but it have nicer user experience.
> 
>> I would also prefer using a bytes interface but I am not sure how to
>> offer that without  either removing the legacy interface of the ratios
>> or by offering a concurrent interface that might be confusing such as
>> when users are looking at the old one and not aware of a new one.
>>
>> Any feedback?
> 
> Sure.
> We don't have any motivation of its interface change.

The more I think about this and the more I would prefer to have an
interface in KB (or pages) that automatically adjusts the old int percentage
in dirty_ratio (the same for dirty_background_ratio).

The parser issue for writing decimal values doesn't seem to be a big
problem, but if the user expects to read an int from vm_dirty_ratio and
instead receives something like 0.125, well... this could break
something. So, IMHO also in this way we're changing the kernel-userspace
interface.

-Andrea
