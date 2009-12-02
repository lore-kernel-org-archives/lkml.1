Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbZLBWlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbZLBWlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 17:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754618AbZLBWlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 17:41:45 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:43082 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266AbZLBWlo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 17:41:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=hnvaFxjUKVyIJF05I0c0L72I0uLvHGPKZcopfZx/+QUZGjQJqcgXifSfxN3uwv6TaM
         jdRiv0wXMVKLKJBHY3doWG85pWbGKC5ceXjYEb0jvMA2hkRobkJaoiast676vlgA0OX8
         vpFtOpLywbkZ98mFSry9pul2QhVvdj2x8gJDo=
MIME-Version: 1.0
In-Reply-To: <15859.1259763330@redhat.com>
References: <8bd0f97a0911280740p24ad49bal64b924a427abfa39@mail.gmail.com> 
	<15859.1259763330@redhat.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 2 Dec 2009 17:41:31 -0500
Message-ID: <8bd0f97a0912021441m5976be3dw29eef46ba4e76bf9@mail.gmail.com>
Subject: Re: avoiding duplicate icache flushing of shared maps on nommu
To: David Howells <dhowells@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Jie Zhang <jie.zhang@analog.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 2, 2009 at 09:15, David Howells wrote:
> Mike Frysinger wrote:
> +               flush_icache_range(region->vm_start,
> +                                  region->vm_end - region->vm_start);
> -               flush_icache_range(result, result + len);

actually, there's one typo here.  you want:
flush_icache_range(region->vm_start, region->vm_end);

it doesnt crash on blackfin systems as addresses not in icache get
nopped, but it was causing large delays on exec mappings.  i thought
this was due to the nic on the board i was using as it's hitting some
weird pauses by itself.
-mike
