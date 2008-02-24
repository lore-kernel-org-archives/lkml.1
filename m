Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbYBXSrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbYBXSrh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 13:47:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbYBXSr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 13:47:27 -0500
Received: from smtp-dmz-230-sunday.dmz.nerim.net ([195.5.254.230]:57112 "EHLO
	kellthuzad.dmz.nerim.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750904AbYBXSr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 13:47:27 -0500
X-Greylist: delayed 1997 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Feb 2008 13:47:26 EST
Message-ID: <47C1B374.6030502@plouf.fr.eu.org>
Date: Sun, 24 Feb 2008 19:12:04 +0100
From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Organization: Plouf !
User-Agent: Mozilla Thunderbird 1.0.6 (Windows/20050716)
X-Accept-Language: fr,en
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Unknown <borg@uu3.net>, linux-kernel@vger.kernel.org,
       dann frazier <dannf@debian.org>
Subject: Re: PROBLEM: 2.4.36.1 hangs.
References: <Pine.LNX.4.64.0802221452350.5082@cube> <20080223083044.GA24136@1wt.eu>
In-Reply-To: <20080223083044.GA24136@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Willy Tarreau wrote :
> 
> On Fri, Feb 22, 2008 at 03:08:30PM +0100, Unknown wrote:
> 
>>2) 2.4.36.1 hangs during compilation of lighttpd-1.4.18.
>>   It is probably during ext2_readdir() but I cannot confirm that..
>>   Currently it only happens during compilation of lighttpd-1.4.18, always
>>   in the same place. [...]

I experience the same problem when executing "ls /etc".

> OK, could you please try to revert the attached patch (patch -Rp1) to see if
> this fixes the problem for you ? Please keep Dann and me in CC as it's not
> easy to spot 2.4-related threads on LKML these days!
> 
> ----
> 
> commit c30306fb287323591c854a0982d9fa5351859b45
> Author: dann frazier <dannf@debian.org>
> Date:   Mon Jan 21 17:13:06 2008 -0700
> 
>     ext2_readdir() filp->f_pos fix

The patch didn't revert cleanly because of the two subsequent 
ext2-related patches, so I had to revert the three of them. It fixed the 
problem. Then I applied only the "ext2_readdir() filp->f_pos fix" patch 
again and the problem came back. HTH.
