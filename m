Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbYHJU0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbYHJU0R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 16:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbYHJU0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 16:26:05 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:24642 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbYHJU0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 16:26:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:x-archive:mime-version:content-type:sender;
        b=ql5L2FCQbKqIzL6z34AfW8HH19Sw0FEMbKHigJvmsiHbksfZEia5KvW2cXWSAK/lCW
         e3Pu+Iyz1XuVihdBjfQ+t+egmF7pO7KAkPwtMD8HX4GOlzTeNiLwjE4VJY4ob10s+J9Y
         JIwlkL/b7Urn7X0vtJKiXOdtELPhQW6Za20xM=
Date: Sun, 10 Aug 2008 17:25:55 -0300 (BRST)
From: =?ISO-8859-15?Q?Fr=E9d=E9ric_L=2E_W=2E_Meunier?= <2@pervalidus.net>
To: Jonathan McDowell <noodles@earth.li>
cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: X "Hangs" with RS690 + 2.6.26
In-Reply-To: <20080810191823.GB4977@earth.li>
Message-ID: <alpine.LNX.1.10.0808101722440.4876@pervalidus>
References: <20080725094334.GC30002@earth.li> <alpine.DEB.0.82.0807251107400.30593@skynet.skynet.ie> <20080801160256.GV30002@earth.li> <alpine.LNX.1.10.0808090541320.4876@pervalidus> <20080810191823.GB4977@earth.li>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
X-Archive: encrypt
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-795397367-1218399960=:4876"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-795397367-1218399960=:4876
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Sun, 10 Aug 2008, Jonathan McDowell wrote:

> On Sat, Aug 09, 2008 at 05:47:42AM -0300, Frédéric L. W. Meunier wrote:
>> On Fri, 1 Aug 2008, Jonathan McDowell wrote:
>>> On Fri, Jul 25, 2008 at 11:10:07AM +0100, Dave Airlie wrote:
>>>>> I've started to see "hangs" with X on an ATI RS690 with a 2.6.26 kernel.
>>>>> The symptoms are that load average goes up, X stops accepting keypresses
>>>>> or mouse clicks, but the cursor still moves around the screen in
>>>>> response to the mouse being moved. I can't switch to a VT but can ssh in
>>>>> remotely to see that things are still running. I don't seem to be able
>>>>> to kill X but "shutdown -r now" cleanly reboots.
>>>>>
>>>>> radeon driver is recent git - 1c5858484da4fb1c9bc3ac3b4d7a97863ab99730
>>>>> but I've seen it with older revisions too.
>>>>>
>>>>> It can take a couple of days for me to hit the problem, so a git bisect
>>>>> could be a lengthy process. If anyone has any suggestions about faster
>>>>> ways to track down the issue I'd like to hear them.
>>>>
>>>> git log v2.6.25..v2.6.26 drivers/char/drm
>>>>
>>>> 5e35eff13f7dd0f5c1d82b3b4708b2f7a5f44113
>>>> 5cfb6956073a9e42d44a26790b7800980634d037
>>>
>>> No joy.
>>>
>>>> d396db321bcaec54345e7e9e87cea8482d6ae3a8
>>>
>>> I thought this might be it; nearly 5 days of uptime rather than the
>>> usual less than 2. But I got the same symptoms today so I'll continue
>>> working down the list.
>>>
>>>> 259434acccbc823ee8bc00b2d2689ccccd25e1fd
>>>> d7463eb41d88a39de2653fd41857c4ccddb8707b
>>>> 45e519052e8f583a709edd442a23f59581d3fe42
>>>> 2735977b12cb0f113aae24afff04747b6d0f5bf1
>>>> 3722bfc607d46275369865c02fe8694486d640b5
>>>> fa0d71b967506031f7cb08ced6095d1c4f988594
>>>> 9f18409ea3d778a171a9505c0a849d846f352bd0
>>
>> Any joy ?
>
> 259434acccbc823ee8bc00b2d2689ccccd25e1fd
> d7463eb41d88a39de2653fd41857c4ccddb8707b
> 45e519052e8f583a709edd442a23f59581d3fe42
>
> all don't seem to be the problem. It's getting harder to do the reverts
> and I'm away this week so I haven't got any further yet.
>
>> I apparently have the same problem with my RS690. I noticed it after
>> upgrading from 2.6.25 to 2.6.26, alongside xorg-server (1.4.99.904 to
>> 1.4.99.905) and Mesa (7.1-rc1 to 7.1-rc3). The ATI driver is 6.9.0.
>>
>> Here it always freezes in a few minutes or less than an hour.  When it
>> happens, I'm not running any 3D application and the CPU is idle. I may
>> be just typing something in a shell. But it works disabling DRI.
>
> Likewise, I'm not doing anything 3D related (at least, not consciously).

BTW, I forgot to mention that. Here the motherboard is a
Gigabyte GA-MA69VM-S2. When it happens and I use SysRq to
reboot, it doesn't post in the BIOS screen. I have to press
reset.
--8323328-795397367-1218399960=:4876--
