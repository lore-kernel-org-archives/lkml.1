Return-Path: <linux-kernel-owner+w=401wt.eu-S1757923AbZFVS7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbZFVS7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 14:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbZFVS7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 14:59:07 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:41207 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbZFVS7G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 14:59:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=r9X4bRVngUx+iMJglj1Qc2B726c2fYevKu1GNTgkPARj1lAqGtrGaA9fvKQRBMRkE7
         mZYTDO8+mmZzh7dOc+RU/MXYIdEy6XSAkYWbLEZwo80JOSs8IRmR5wcazXDUGbVjEOFg
         yUmTly1Y4wUUKmg56N4cbg9DCcEU/gxDLTlkU=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0906221121100.3240@localhost.localdomain>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie>
	 <4A3DABE1.50309@mit.edu>
	 <alpine.DEB.2.00.0906210615450.6234@skynet.skynet.ie>
	 <alpine.LFD.2.01.0906210945170.3119@localhost.localdomain>
	 <alpine.LFD.2.01.0906210948340.3119@localhost.localdomain>
	 <cb0375e10906211150v7c54f355ga0066eccc128085@mail.gmail.com>
	 <alpine.LFD.2.01.0906211223190.3119@localhost.localdomain>
	 <alpine.DEB.2.00.0906212336200.20307@skynet.skynet.ie>
	 <4A3F3E3A.2030202@shipmail.org>
	 <alpine.LFD.2.01.0906221121100.3240@localhost.localdomain>
Date: Mon, 22 Jun 2009 14:59:07 -0400
X-Google-Sender-Auth: 4016159a29a95396
Message-ID: <cb0375e10906221159u56fcf275yff34b93a39e07186@mail.gmail.com>
Subject: Re: [git pull] drm: previous pull req + 1.
From: Andrew Lutomirski <luto@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>,
       Dave Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
       dri-devel@lists.sf.net, Jerome Glisse <jglisse@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/22 Linus Torvalds <torvalds@linux-foundation.org>:
>
>
> On Mon, 22 Jun 2009, Thomas Hellström wrote:
>>
>> It would be very helpful if we could introduce an fbdev mutex that protects
>> fbdev accesses to the kernel map and to the fbdev acceleration functions.
>
> Not going to happen.
>
> Why? 'printk'.
>
> If you can't handle printk, then you're basically useless. And printk
> absolutely -has- to work in bad situations (the most important messages
> could happen in any context).

What if we only guaranteed that the framebuffer is mapped when it's
showing on the screen?

printk doesn't need to write to the framebuffer immediately when X
isn't running (since the framebuffer isn't shown) and presumably the
framebuffer needs to be pinned somewhere when it's being displayed
anyway.  This would involve fbcon knowing how to buffer text to be
shown later so that printk still works in interrupt context.

--Andy
