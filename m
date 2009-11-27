Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915AbZK0DIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbZK0DIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 22:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbZK0DIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 22:08:34 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:53496 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbZK0DId convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 22:08:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZOOsXjfyASCI9+DjvgQ4hMoJ5Oe0F43HJQNWM41doWB1useT8RNfpwSE/yxp2pX/s5
         bWruNBaRvbvMGJuCA9q3mxPKByVFY1wm7fFaGL4Md5tif5mfTT5KbUnf+DGUE69Yrlpf
         AdhSkG/EGJjNZc8Gw5rembiTmV7ddgKOPzyiw=
MIME-Version: 1.0
In-Reply-To: <20091127114511.bbb43d5a.kamezawa.hiroyu@jp.fujitsu.com>
References: <cover.1259255307.git.kirill@shutemov.name>
	 <bc4dc055a7307c8667da85a4d4d9d5d189af27d5.1259255307.git.kirill@shutemov.name>
	 <8524ba285f6dd59cda939c28da523f344cdab3da.1259255307.git.kirill@shutemov.name>
	 <20091127092035.bbf2efdc.nishimura@mxp.nes.nec.co.jp>
	 <20091127114511.bbb43d5a.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 27 Nov 2009 08:38:39 +0530
X-Google-Sender-Auth: faf8e8f457a6afc8
Message-ID: <661de9470911261908i4bb51e91v649025e6c75bd91b@mail.gmail.com>
Subject: Re: [PATCH RFC v0 2/3] res_counter: implement thresholds
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       containers@lists.linux-foundation.org, linux-mm@kvack.org,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 8:15 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Fri, 27 Nov 2009 09:20:35 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
>
>> Hi.
>> >
>> > @@ -73,6 +76,7 @@ void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val)
>> >             val = counter->usage;
>> >
>> >     counter->usage -= val;
>> > +   res_counter_threshold_notify_locked(counter);
>> >  }
>> >
>> hmm.. this adds new checks to hot-path of process life cycle.
>>
>> Do you have any number on performance impact of these patches(w/o setting any threshold)?
>> IMHO, it might be small enough to be ignored because KAMEZAWA-san's coalesce charge/uncharge
>> patches have decreased charge/uncharge for res_counter itself, but I want to know just to make sure.
>>
> Another concern is to support root cgroup, you need another notifier hook in
> memcg because root cgroup doesn't use res_counter now.
>
> Can't this be implemented in a way like softlimit check ?
> Filter by the number of event will be good for notifier behavior, for avoiding
> too much wake up, too.

I guess the semantics would vary then, they would become activity
semantics. I think we should avoid threshold notification for root,
since we have no limits in root anymore.

BTW, Kirill, I've been meaning to write this layer on top of
cgroupstats, is there anything that prevents us from using that today?
CC'ing Dan Malek and Vladslav Buzov who worked on similar patches
earlier.

Balbir Singh.
