Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041AbYKVIsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbYKVIsy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 03:48:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbYKVIsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 03:48:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:33628 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbYKVIsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 03:48:45 -0500
Message-ID: <4927C75B.9080509@kernel.org>
Date: Sat, 22 Nov 2008 17:48:27 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       akpm@linux-foundation.org, greg@kroah.com
Subject: Re: [PATCH 5/5] CUSE: implement CUSE - Character device in Userspace
References: <1227190983-5820-1-git-send-email-tj@kernel.org> <1227190983-5820-6-git-send-email-tj@kernel.org> <E1L3bA9-0000Dx-Vb@pomaz-ex.szeredi.hu> <49279324.7010605@kernel.org> <E1L3o2v-0001Nz-Oi@pomaz-ex.szeredi.hu>
In-Reply-To: <E1L3o2v-0001Nz-Oi@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 22 Nov 2008 08:48:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> On Sat, 22 Nov 2008, Tejun Heo wrote:
>> Miklos Szeredi wrote:
>>> On Thu, 20 Nov 2008, Tejun Heo wrote:
>>>> diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
>>>> index 0be9245..d4dcca8 100644
>>>> --- a/include/linux/miscdevice.h
>>>> +++ b/include/linux/miscdevice.h
>>>> @@ -28,6 +28,7 @@
>>>>  #define MPT_MINOR		220
>>>>  #define	HPET_MINOR		228
>>>>  #define FUSE_MINOR		229
>>>> +#define CUSE_MINOR		230
>>> This doesn't work: device numbers have to be allocated by LANANA.
>> My last attempt at LANANA for extended devt didn't get me anywhere and
>> I'm not sure LANANA is handling miscdevice minors at all.
> 
> Back then I did get the fuse device registered in LANANA database
> (http://www.lanana.org/docs/device-list/devices-2.6+.txt)

I switched it back to dynamic minor, so it's a non-issue now.

>>   If you go
>> through the tree, there are quite a few duplicate allocations including
>> FUSE_MINOR.  At any rate, we can definitely try LANANA.
> 
> Ugh, I suppose that's my fault for not putting the definition in
> miscdevice.h (though apparently the duplicates didn't do so either).

Miscdevice minors are spread all over the place especially under archs.
 I tried to move all of them into miscdevice.h but I got scared by the
dups.  :-)

Thanks.

-- 
tejun
