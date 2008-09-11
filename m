Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbYIKV2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbYIKV2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 17:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbYIKV2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 17:28:13 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:44666 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbYIKV2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 17:28:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZtnDIGKT3CXDCulT8o1VUL3V3XnZNCzJ6AY7EqJi/PJlQ5QHdr68F1WDqrMXWzpejm
         kj//sgm/pZhVznC+yCzirO2WWaKlru64MWtRgAqtfK1ypnlhB5sn2AMy3EZSwqMxFxGC
         4avpGfrGnRLwwl3P/bSSRkIInHEYiSTqfpd6U=
Message-ID: <48C98D64.7050909@gmail.com>
Date: Fri, 12 Sep 2008 00:28:04 +0300
From: Maxim Levitsky <maximlevitsky@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jarod Wilson <jwilson@redhat.com>, linux-kernel@vger.kernel.org,
       Jarod Wilson <jarod@redhat.com>, Janne Grunau <j@jannau.net>,
       Christoph Bartelmus <lirc@bartelmus.de>,
       Mario Limonciello <superm1@ubuntu.com>
Subject: Re: [PATCH 01/18] lirc core device driver infrastructure
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <1220933164-10160-2-git-send-email-jwilson@redhat.com> <20080910130851.GC25221@anvil.corenet.prv> <48C8DB0E.30705@redhat.com>
In-Reply-To: <48C8DB0E.30705@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gerd Hoffmann wrote:
> Dmitry Torokhov wrote:
>> Couple of questions - what is missing in the current input core to
>> properly support IR devices?
> 
> One issue is *sending* IR codes.
> Another one is access to the raw IR signal (more on this below).
> 
> Probably 90% of the users are happy without that.
> 
>> Could we try to work it in ininput core and
>> maybe provide LIRC device access through an input handler
>> implementation so that applications do not have to implement 2 types of
>> interfaces?
> 
> Not needed.  Applications don't talk to the lirc device directly, they
> talk to the lircd daemon.  The lircd daemon can handle linux input layer
> devices just fine.  So moving drivers from lirc to the input layer can
> be done transparently to the applications.
> 
> Quite some time ago, back the days when I maintained video4linux, I've
> switched the tv card IR drivers from lirc to the input layer.  Main
> reason for that was that having a in-kernel driver using an out-of-tree
> subsystem was a PITA.  I think these days most (all?) TV card drivers
> use the input layer for the IR remotes frequently shipped with those cards.
> 
> 
> Some more background, using the Hauppauge cards as example, which
> usually use rc5 coding with the remotes.
> 
> The older, bt878 based ones do decoding in hardware (i2c chip).  You'll
> get the decoded rc5 keycode.
> 
> The newer, cx88 based ones just sample the raw IR signal and give you
> that.  The decoding has to be done in software.  The driver can program
> the sample rate and has to do the biphase decoding in software to get
> the rc5 keycodes.  The driver gets that done just fine, and the remote
> shipped with the TV card works without problems.
> 
> The part which doesn't work is supporting *any* remote.  The (newer)
> hardware gives you the raw IR signal, so it is possible to decode any IR
> signal in software.  The missing bit is some way to send the raw IR
> samples to userspace (i.e. the lircd daemon) for decoding.  lirc drivers
> do just that.
Hi,

Just my .02 cents,

I personally don't like the lircd daemon (*), I would like to have all input keycodes in
input layer.
What do you, lirc developers think about making lircd a daemon that injects input events via uinput?


(*) the reason I don't like lircd is that not all applications support it.


Best regards,
	Maxim Levitsky

> 
> HTH,
>   Gerd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

