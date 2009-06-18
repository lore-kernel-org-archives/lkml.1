Return-Path: <linux-kernel-owner+w=401wt.eu-S1759012AbZFRC67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759012AbZFRC67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 22:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758564AbZFRC6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 22:58:45 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:57896 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758343AbZFRC6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 22:58:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=XYyWjlQI+ZRRTJmqPRW+Ded4zWL6DyUXWZPiY87NUw1dbQvvK2wAxaw5I67dIz6Cuq
         BO7t4f1NxvQVFcBlx+wZlKRLYiaFm2M34lBSVYwIykPpqO/+P99lhmAiBEx8DCWEknMr
         0KENn9SCuc0UctjGb3TOMHdSyNW7QhAYFTbBo=
Date: Thu, 18 Jun 2009 11:00:51 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Tao Ma <tao.ma@oracle.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [Patch BUGFIX] kcore: fix its wrong size on x86_64
Message-ID: <20090618030051.GA6133@cr0.nay.redhat.com>
References: <2375c9f90906072341o2cded749m45bdddfdb499469@mail.gmail.com> <4A2CC52B.9010602@oracle.com> <2375c9f90906081743p77934f47n8ba1a018d333b95b@mail.gmail.com> <m1ab4i11zx.fsf@fess.ebiederm.org> <20090611050929.GA2706@cr0.nay.redhat.com> <m11vpqvozl.fsf@fess.ebiederm.org> <20090613040958.GA2959@cr0> <m17hzdhkr8.fsf@fess.ebiederm.org> <2375c9f90906160829g3d605836yb4c5b9beeac50c5f@mail.gmail.com> <m1my88568n.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m1my88568n.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 12:27:36PM -0700, Eric W. Biederman wrote:
>Américo Wang <xiyou.wangcong@gmail.com> writes:
>>> I think a case can be made either way.  In practice neither answer
>>> gives us a dense offset space on x86_64 so I think I prefer the
>>> current definition which sets or clears the high bits as opposed
>>> to something that mangles the address more.
>>>
>>
>> I am trying to dig more... There must be something wrong there.
>
>How so?

See what you will get for kc_vaddr_to_offset(__va(0))?
It is supposed to be 0.


>
>>> It uses get_kcore_size and (size_t)high_memory - PAGE_OFFSET + PAGE_SIZE;
>>> The second definition being bogus as it has nothing to do with which
>>> offsets are accepted.
>>
>> Agreed. Maybe we can just remove the second one and update the doc?
>
>Yes.  It isn't critical but reducing confusion is good.
>Do you want to cook up the patch for that?

Yes, I am cooking a patch set... will send them when ready.
