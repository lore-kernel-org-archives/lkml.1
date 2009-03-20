Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbZCTRBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbZCTRBy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 13:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756849AbZCTRBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 13:01:45 -0400
Received: from relay.gothnet.se ([82.193.160.251]:12694 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755326AbZCTRBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 13:01:44 -0400
Message-ID: <49C3CB88.2000202@shipmail.org>
Date: Fri, 20 Mar 2009 17:59:52 +0100
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>
Organization: VMware
User-Agent: Thunderbird 1.5.0.7 (X11/20060921)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       Daniel Stone <daniel@fooishbar.org>,
       Richard Purdie <rpurdie@linux.intel.com>,
       Sindhudweep Sarkar <sindhudweep.sarkar@gmail.com>,
       dri-devel@lists.sourceforge.net
Subject: Re: [patch 0/5] Intel Poulsbo/Morrestown DRM driver and DRM core
 changes
References: <20090319040809.GA29249@kroah.com>	<6c046ab30903190903r298a0334n939e64403b8aeda6@mail.gmail.com>	<20090319162719.GB32078@kroah.com>	<20090320060823.GF32194@fooishbar.org>	<20090320145340.GA11347@kroah.com>	<20090320150032.31ef6a51@lxorguk.ukuu.org.uk> <20090320155010.GA13556@kroah.com>
In-Reply-To: <20090320155010.GA13556@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Fri, Mar 20, 2009 at 03:00:32PM +0000, Alan Cox wrote:
>   
>>>> By the same logic, would you support including the proprietary NVIDIA
>>>> driver while we wait for Nouveau to catch up?
>>>>         
>>> The license of the NVIDIA driver does not allow that to even be a
>>> possibility.
>>>       
>> I'm not convinced this is any different. If you accept the 3D changes you
>> step into a dangerous world of estoppel and since it has many
>> rightsholders also the wonderful world of contributory infringement. It
>> really really needs lawyers to look into it.
>>     
>
> I would hope that Intel's lawyers would have done such a thing before
> releasing the kernel and xorg code under the licenses that they did :)
>
>   
>> Now the other way to do it that might be more productive and simpler
>> would be to rip all the 3D crap out of that driver and just include the
>> minimum needed 2D bits for the open source X driver. Makes the code
>> smaller and cleaner, avoids an legal questions and lets people get on
>> with real work.
>>     
>
> Hm, that sounds fine to me.
>
> Does that mean that all of these drm patches that I posted are _only_
> needed for the 3d portions of the driver?  If I rip out the portions of
> the psb kernel driver that need these changes, do I end up with an
> working 2d driver as well?  Richard and Thomas, any thoughts here?
>
> thanks,
>
> greg k-h
>
>   
Greg,
Let's not forget the video stuff. I'm not sure about the status of that.

But all the other patches are needed for 2D functionality and kernel 
modesetting.
If you want to strip 3D you can strip.

psb_schedule.[ch] - The 3D scheduler.
psb_xhw.c - The interface to the binary X server module.
psb_scene.c - The 3D scene tracker.

and anything that appears unused after that.
This means you lose Render acceleration and textured video and 
downscaling in the X server as well,
although accelerated rotation should still work, since it uses the 2D 
engine.

I think the video acceleration sits in

psb_msvdx.c
psb_msvdxinit.c
lnc_topaz.c
lnc_topazinit.c

/Thomas



