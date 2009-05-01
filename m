Return-Path: <linux-kernel-owner+w=401wt.eu-S1761298AbZEAOMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761298AbZEAOMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbZEAOMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:12:15 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:61442 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491AbZEAOMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:12:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=q8Vu1kHphLsTEzeNq3mvM9AbYLJsHHqZF08v0QejK591VniUPM2xTXBXR4Qo5nzbbo
         YrscIuzKNdPFQlpLkJiodrnmYy8vrMwbSbooOGsM+/eL+W7WrN0nE/38+zPotHz2n+OB
         rvLzclY/ubX8b/co+yZq0XxgYe+T+F0eAglPA=
Date: Fri, 1 May 2009 16:12:09 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Alessio Igor Bogani <abogani@texware.it>, J@pimp.vs19.net
Subject: Re: [PATCH 0/6] kill-the-BKL/reiserfs3: performance improvements,
	faster than Bkl based scheme
Message-ID: <20090501141208.GJ6011@nowhere>
References: <1241145862-21700-1-git-send-email-fweisbec@gmail.com> <20090501053540.GC5983@elte.hu> <1241180316.3783.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241180316.3783.3.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 02:18:36PM +0200, Thomas Meyer wrote:
> Am Freitag, den 01.05.2009, 07:35 +0200 schrieb Ingo Molnar:
> > 
> > I've pulled it and have also merged -rc4 into the kill-the-BKL tree, 
> > which can picked up from here:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core/kill-the-BKL
> > 
> > So for comparative benchmarking, vanilla v2.6.30-rc4 (which has the 
> > BKL) can be compared against latest kill-the-BKL
> 
> Hi,
> 
> Kernel gets soft-locked-up in somewhere in initrd:
> 
> See
> http://m3y3r.de/bilder/img_0524.jpg
> http://m3y3r.de/bilder/img_0525.jpg
> http://m3y3r.de/bilder/img_0526.jpg
> http://m3y3r.de/bilder/img_0527.jpg
> http://m3y3r.de/bilder/img_0528.jpg
> http://m3y3r.de/bilder/img_0529.jpg


Looks like someone owns the kernel lock and is sleeping
with the assumption it releases the lock, like the old bkl did.

 
> config is:
> http://m3y3r.de/bilder/config-2.6.30-rc4-ktb


Thanks, I will try it out once I have some time.


> greets
> thomas
> 
> 

