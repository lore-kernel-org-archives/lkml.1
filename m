Return-Path: <linux-kernel-owner+w=401wt.eu-S1755731AbZBKLdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbZBKLdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 06:33:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbZBKLdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 06:33:25 -0500
Received: from an-out-0708.google.com ([209.85.132.240]:27813 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbZBKLdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 06:33:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ixNgLVhv1yHceUauj9r7/CclCIT3R0hGh/ALAU1rEbFusNSoi9QhPn0vtXqwsUYjp2
         XobD4f4u5R9/iI5DUYmj+rrDZCqY1Vm5eU9wrCavV8iNGNFtsa4zr660GCSeGZPjzaTt
         uxyttp8qXVMvvekDnJZ1JOeaseAv1mKxoQan0=
MIME-Version: 1.0
In-Reply-To: <1234295613.4699.1.camel@laptop>
References: <b6a2d2e20902091130ha452a97rcfaa2972bfdbe710@mail.gmail.com>
	 <1234209174.5951.165.camel@laptop>
	 <b6a2d2e20902091204p2391799p160ce13971e9f779@mail.gmail.com>
	 <1234271177.23438.24.camel@twins>
	 <b6a2d2e20902100646q6c7073cse86b8f5790a120ac@mail.gmail.com>
	 <1234281602.23438.96.camel@twins>
	 <b6a2d2e20902100932i475c1ee8va99de6e433a6d89a@mail.gmail.com>
	 <1234295613.4699.1.camel@laptop>
Date: Wed, 11 Feb 2009 11:33:22 +0000
Message-ID: <b6a2d2e20902110333j37cf76b4v73abc2be3631738c@mail.gmail.com>
Subject: Re: cgroup, RT reservation per core(s)?
From: Rolando Martins <rolando.martins@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/10/09, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2009-02-10 at 17:32 +0000, Rolando Martins wrote:
>  >
>  > For helping others:
>  >
>  > mkdir /dev/cpuset
>  > mount -t cgroup -o cpuset none /dev/cpuset
>  > cd /dev/cpuset
>  > echo 0 > cpuset.sched_load_balance
>
>
> I'm not quite sure that its allowed to disable load-balance before
>  creating children. Other than that it looks ok.
>
>
>  > mkdir A
>  > echo 0-1 > A/cpuset.cpus
>  > echo 0 > A/cpuset.mems
>  > mkdir B
>  > echo 2-3 > B/cpuset.cpus
>  > echo 0 > B/cpuset.mems
>  >
>  >
>  > mount -t cgroup -o cpu none /dev/sched_domain
>  > cd /dev/sched_domain
>  > mkdir 1
>  > echo cpu.rt_runtime_ns > 1/cpu.rt_runtime_ns
>  > mkdir 1/2
>  > echo 33333 > 1/2/cpu.rt_runtime_ns
>  > mkdir 1/3
>  > echo 33333 > 1/3/cpu.rt_runtime_ns
>  > mkdir 1/4
>  > echo 33333 > 1/3/cpu.rt_runtime_ns
>  >
>  > For example, setting the current shell to a specific cpuset(A) and
>  > sched(1/2):
>  >
>  > echo $$ > /dev/cpuset/A/tasks
>  > echo $$ > /dev/sched_domain/1/2/tasks
>  > "execute program"
>
>

Hi again,

is there any way to have multiple "distinct" sched domains, i.e.:
mount -t cgroup -o cpu none /dev/sched_domain_0
... setup sched_domain_0 (ex:  90% RT, 10% Others)
mount -t cgroup -o cpu none /dev/sched_domain_1
... setup sched_domain_1 (ex:  20% RT, 80% Others)
Then give sched_domain_0 to cpuset A and sched_domain_1 to B?

Thanks,
Rol
