Return-Path: <linux-kernel-owner+w=401wt.eu-S1753590AbZDVAt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbZDVAt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 20:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbZDVAtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 20:49:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50704 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752417AbZDVAtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 20:49:20 -0400
Message-ID: <49EE69C2.9030908@cn.fujitsu.com>
Date: Wed, 22 Apr 2009 08:50:10 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Mike Snitzer <snitzer@redhat.com>,
       device-mapper development <dm-devel@redhat.com>, nauman@google.com,
       fernando@oss.ntt.co.jp, linux-kernel@vger.kernel.org, jmoyer@redhat.com,
       jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com
Subject: Re: dm-ioband: Test results.
References: <20090420.172959.193682665.ryov@valinux.co.jp> <e98e18940904200207y62eca680t7cf938049375f4b3@mail.gmail.com> <20090421.210614.112619728.ryov@valinux.co.jp> <20090421.211051.183023683.ryov@valinux.co.jp> <20090421135723.GA13953@redhat.com> <20090421141607.GA22619@redhat.com>
In-Reply-To: <20090421141607.GA22619@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Tue, Apr 21, 2009 at 09:57:23AM -0400, Mike Snitzer wrote:
>> On Tue, Apr 21 2009 at  8:10am -0400,
>> Ryo Tsuruta <ryov@valinux.co.jp> wrote:
>>
>>> Hi Nauman,
>>>
>>>>> The real question is, once you create a version of dm-ioband that
>>>>> co-operates with CFQ scheduler, how that solution would compare with
>>>>> the patch set Vivek has posted? In my opinion, we need to converge to
>>>>> one solution as soon as possible, so that we can work on it together
>>>>> to refine and test it.
>>>> I think I can do some help for your work. but I want to continue the
>>>> development of dm-ioband, because dm-ioband actually works well and
>>>> I think it has some advantages against other IO controllers.
>>>>   - It can use without cgroup.
>>>>   - It can control bandwidth on a per partition basis.
>>>>   - The driver module can be replaced without stopping the system.
>>> In addition, dm-ioband can run on the RHEL5.
>> RHEL5 compatibility does not matter relative to merging an I/O bandwidth
>> controller upstream.  So both the "can [be] use without cgroup" and "can
>> run on RHEL5" features do not help your cause of getting dm-ioband
>> merged upstream.  In fact these features serve as distractions.
> 
> Exactly. I don't think that "it can be used without cgroup" is a feature
> or advantage. To me it is a disadvantage and should be fixed. cgroup is
> standard mechanism to group tasks arbitrarily and we should use that to make
> things working instead of coming up with own ways of grouping things and
> terming it as advantage.
> 

I agree. And for the case of cpu scheduler, there are user group scheduler
and cgroup group scheduler, but Peter said he would like to see user group
scheduler to be removed.

> What do you mean by "The driver module can be replaced without stopping
> the system"? I guess you mean that one does not have to reboot the system
> to remove ioband device? So if one decides to not use the cgroup, then
> one shall have to remove the ioband devices, remount the filesystems and
> restart the application?
> 
> With cgroup approach, if one does not want things to be classified, a user
> can simply move all the tasks to root group and things will be fine. No
> remounting, no application stopping etc. So this also does not look like
> an advantage instead sounds like an disadvantage.
> 
> Thanks
> Vivek
