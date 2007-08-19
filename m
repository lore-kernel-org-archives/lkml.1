Return-Path: <linux-kernel-owner+w=401wt.eu-S1756568AbXHSQgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbXHSQgS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 12:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbXHSQgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 12:36:10 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:56480 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbXHSQgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 12:36:09 -0400
X-Greylist: delayed 1280 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Aug 2007 12:36:09 EDT
Message-ID: <46C86B6C.8090209@home.nl>
Date: Sun, 19 Aug 2007 18:10:20 +0200
From: Rene Herman <rene.herman@home.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: 7eggert@gmx.de
CC: Mike Mohr <akihana@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: group ownership of tun devices -- nonfunctional?
References: <8Tpwf-3Nb-1@gated-at.bofh.it> <E1IMnHK-00012c-VC@be1.lrz>
In-Reply-To: <E1IMnHK-00012c-VC@be1.lrz>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Neem contact op met support@home.nl voor meer informatie
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2007 06:05 PM, Bodo Eggert wrote:

> IMHO the check is broken:
> 
> +               if (((tun->owner != -1 &&
> +                     current->euid != tun->owner) ||
> +                    (tun->group != -1 &&
> +                     current->egid != tun->group)) &&
> +                    !capable(CAP_NET_ADMIN))
>                         return -EPERM;
> 
> It should be something like:
> 
> +               if (!((tun->owner == tun->owner) ||
> +                     (tun->group == tun->group) ||

???

> +                     capable(CAP_NET_ADMIN)))
>                         return -EPERM;
> 
> Please verify and forward to the maintainers if my guess appears to be correct.

Rene.
