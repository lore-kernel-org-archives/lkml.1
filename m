Return-Path: <linux-kernel-owner+w=401wt.eu-S1754343AbZIWHUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbZIWHUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 03:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268AbZIWHUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 03:20:43 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:59865 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbZIWHUn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 03:20:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=deZARpzimtoaPR2Fg7sHNHehztGM5wevDQbeGrgIXnK+Df1BpECH8wE4TvIG/IJo/6
         DEN36NBDyfi6c0tT2VrmYj2zJYxC0BpvWQ8AJD4C11nmWPdclN6DKp590HGLZheO/9IX
         z9CT/L8bpDneXuubUoFIvxk0wyx7QVNoMdk9Y=
MIME-Version: 1.0
In-Reply-To: <4AB8FC88.8020608@s5r6.in-berlin.de>
References: <4AB8FC88.8020608@s5r6.in-berlin.de>
Date: Wed, 23 Sep 2009 10:20:46 +0300
X-Google-Sender-Auth: f54ad4649d4c87e2
Message-ID: <84144f020909230020m3a562220x8eda4f102e452c48@mail.gmail.com>
Subject: Re: v2.6.31-7381-g7fa0772: new build warnings: kmemcheck, 
	__deprecated, hugetlb, radeon
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, Vegard Nossum <vegard.nossum@gmail.com>,
       Eric B Munson <ebmunson@us.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Dave Airlie <airlied@linux.ie>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 7:34 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> Latest git compiles with extreme noise:
>
> In file included from include/net/inet_connection_sock.h:23,
>                 from include/linux/tcp.h:178,
>                 from include/linux/ipv6.h:215,
>                 from include/net/ipv6.h:16,
>                 from include/linux/sunrpc/clnt.h:25,
>                 from include/linux/nfs_fs.h:52,
>                 from kernel/sysctl.c:48:
> include/net/inet_sock.h: In function 'inet_reqsk_alloc':
> include/net/inet_sock.h:208: warning: ISO C90 forbids mixed declarations and
> code
>
> Vegard, this is obviously caused by commit
> 45e3ff82708c65c895d5c5882aff17ecf62a80b5.
>
> $ grep KMEMCH .config
> CONFIG_HAVE_ARCH_KMEMCHECK=y
>
> (I.e. CONFIG_KMEMCHECK is off.)

Curious, I haven't seen this before. Is it coming from the
BUILD_BUG_ON() in kmemcheck_annotate_bitfield()? I can't seem to spot
the error.

                       Pekka
