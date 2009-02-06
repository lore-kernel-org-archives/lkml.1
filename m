Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbZBFWkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbZBFWkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 17:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbZBFWkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 17:40:12 -0500
Received: from relay.gothnet.se ([82.193.160.251]:64514 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750831AbZBFWkL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 17:40:11 -0500
Message-ID: <498CBC3B.6010609@shipmail.org>
Date: Fri, 06 Feb 2009 23:39:55 +0100
From: =?ISO-8859-15?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Eric Anholt <eric@anholt.net>, DRI <dri-devel@lists.sourceforge.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Gem GTT mmaps..
References: <498A1760.7010108@shipmail.org> <200902060914.59956.jbarnes@virtuousgeek.org> <498CAD2F.5070806@shipmail.org> <200902061424.02906.jbarnes@virtuousgeek.org>
In-Reply-To: <200902061424.02906.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
X-BitDefender-Scanner: Mail not scanned due to license constraints
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Friday, February 6, 2009 1:35 pm Thomas Hellström wrote:
>   
>> Jesse Barnes wrote:
>>     
>>> On Thursday, February 5, 2009 10:37 am Jesse Barnes wrote:
>>>       
>>>> So if we leave the lookup reference around from the GTT mapping ioctl,
>>>> that would take care of new mappings.  And if we added/removed
>>>> references at VM open/close time, we should be covered for fork.  But is
>>>> it ok to add a new unref in the finish ioctl for GTT mapped objects?  I
>>>> don't think so, because we don't know for sure if the caller was the one
>>>> that created the new fake offset (which would be one way of detecting
>>>> whether it was GTT mapped). Seems like we need a new unmap ioctl?  Or we
>>>> could put the mapping ref/unref in libdrm, where it would be tracked on
>>>> a per-process basis...
>>>>         
>>> Ah but maybe we should just tear down the fake offset at unmap time; then
>>> we'd be able to use it as an existence test for the mapping and get the
>>> refcounting right.  The last thing I thought of was whether we'd be ok in
>>> a map_gtt -> crash case.  I *think* the vm_close code will deal with
>>> that, if we do a deref there?
>>>       
>> Yes, an mmap() is always paired with a vm_close(), and the vm_close()
>> also happens in a crash situation.
>>     
>
> This one should cover the cases you found.
>   - ref at map time will keep the object around so fault shouldn't fail
>   - additional threads will take their refs in vm_open/close
>   - unmap will unref and remove mmap_offset allowing object to be freed
>
>   
Jesse,

Yes, it looks OK to me.
A short question, though, when is i915_gem_sw_finish_ioctl called? Is it 
possible that the client may still think its mmap offset is valid?

Thomas




