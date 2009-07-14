Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbZGNS6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbZGNS6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 14:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536AbZGNS6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 14:58:10 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:42919 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543AbZGNS6J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 14:58:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lqd4vLFEyBOMZ7otKj8YcPh1n0W50paiexBVWddX/jIQetjlVfDni8oA4dRud1Gv7B
         bcgUmKIdSFQAKHsXDRIYea3nSSZvXKZymP7PuEWQxeXQyJgYLctsji1ciPkaxfQKnSwb
         JdXv6KvA1MdZhE+FAnXVuQDr6U8B3jpR6xvyE=
MIME-Version: 1.0
In-Reply-To: <20090714.113348.155881037.davem@davemloft.net>
References: <cb0375e10904010840n1543a890w9039465d0f80ffcc@mail.gmail.com>
	 <20090404.170539.148727646.davem@davemloft.net>
	 <ce0170d90907141017h732c2cd7ja5990303093b6edd@mail.gmail.com>
	 <20090714.113348.155881037.davem@davemloft.net>
Date: Tue, 14 Jul 2009 14:58:06 -0400
Message-ID: <cb0375e10907141158l345742e3t1a252d1d1d0db526@mail.gmail.com>
Subject: Re: [PATCH 1/1] Tell linkwatch about new interfaces
From: Andrew Lutomirski <amluto@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: eeeesti@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 2:33 PM, David Miller<davem@davemloft.net> wrote:
> From: Sergio Luis <eeeesti@gmail.com>
> Date: Tue, 14 Jul 2009 14:17:21 -0300
>
>> is this patch incorrect, though? with the linkwatch_fire_event() call,
>> the rfc2863 operstate will be set for everyone at device register
>> time.
>
> The issue is dumb drivers that do not manage their link state
> at all.  We want them to always have their links up, from the
> moment they are registered.

Such dumb drivers still end up with bogus operstate.

>
> This is especially important for virtual devices.

$ ip link show lo
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00

I've never noticed this causing a problem, but it seems a little
silly.  Presumably lo should be "UP."

--Andy

>
