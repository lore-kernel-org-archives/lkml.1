Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293AbZJAAr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbZJAAr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 20:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755197AbZJAAr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 20:47:58 -0400
Received: from bay0-omc1-s28.bay0.hotmail.com ([65.54.246.100]:13311 "EHLO
	bay0-omc1-s28.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755147AbZJAAr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 20:47:57 -0400
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Sep 2009 20:47:57 EDT
Message-ID: <BAY109-W5070D29833BA82A9F7A4E2C3D30@phx.gbl>
X-Originating-IP: [173.64.154.25]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <arjan@infradead.org>, <eric.dumazet@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, <schwidefsky@de.ibm.com>,
       <tglx@linutronix.de>, <johnstul@us.ibm.com>,
       <linux-kernel@vger.kernel.org>
Subject: RE: Linux 2.6.32-rc1
Date: Wed, 30 Sep 2009 17:42:02 -0700
Importance: Normal
In-Reply-To: <20090930173102.2d54534c@infradead.org>
References: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain>
 <4AC060AE.1090401@gmail.com>
 <alpine.LFD.2.01.0909280829100.3349@localhost.localdomain>
 <20090928191506.40b61793@mschwide.boeblingen.de.ibm.com>
 <4AC10365.7090802@gmail.com> <4AC2712C.4080901@gma
X-OriginalArrivalTime: 01 Oct 2009 00:42:02.0916 (UTC) FILETIME=[FE336E40:01CA422F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 <20090930173102.2d54534c@infradead.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0




----------------------------------------
> Date: Wed=2C 30 Sep 2009 17:31:02 +0200
> From: arjan@infradead.org
> To: eric.dumazet@gmail.com
> CC: torvalds@linux-foundation.org=3B schwidefsky@de.ibm.com=3B tglx@linut=
ronix.de=3B johnstul@us.ibm.com=3B linux-kernel@vger.kernel.org=3B a.p.zijl=
stra@c
> Subject: Re: Linux 2.6.32-rc1
>
> On Wed=2C 30 Sep 2009 17:27:05 +0200
> Eric Dumazet  wrote:
>>
>>> + pop %edi
>> Why do you pop flags in edi=2C to later re-push them ?
>>
>>> + cli
>
> because here I disable interrupts
But popping the flags to edi to later repush them should not be necessary u=
nless you are switching esp.


Getting rid of this will allow the push/pop edi at the beginning/end to
be eliminated=2C reducing code size as well as increasing the speed.
> (basically this is local_irq_save() )
>>
>>
>>> + xchg (%esi)=2C %ebx
>>> + xchg 4(%esi)=2C %ecx
>> How this sequence is guaranteed to be atomic with other cpus ?
>
> it is not. this is the 486 implementation which is !SMP
> (just like the current cmpxchg64() fallback)



BTW=2C NT4 had a SMP version of this emulation that used a simple spinlock:
http://www.geoffchappell.com/viewer.htm?doc=3Dstudies/windows/km/cpu/cx8.ht=
m

Yuhong Bao
 		 	   		  =0A=
_________________________________________________________________=0A=
Insert movie times and more without leaving Hotmail=AE.=0A=
http://windowslive.com/Tutorial/Hotmail/QuickAdd?ocid=3DTXT_TAGLM_WL_HM_Tut=
orial_QuickAdd_062009=
