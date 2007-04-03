Return-Path: <linux-kernel-owner+w=401wt.eu-S1750999AbXDCDIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750999AbXDCDIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 23:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbXDCDIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 23:08:51 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:28418 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbXDCDIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 23:08:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=hZSytN2pri5zKl+evt57eAOd3xoLThXsZ+ExeGG1vA2rJ7CiATa4Hd6cKeBMezL7MR2gaWdJ5maWWzkZ57J4wAn9hreltHaLY4mNKS0G62LGgGYOgv9kqE7Q/aq7jh5/u05flzHL6X55279Bh+9lW0njpMhU7cJcJVmCwu570Lo=
Message-ID: <4611C538.7050007@gmail.com>
Date: Tue, 03 Apr 2007 12:08:40 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: James Bottomley <James.Bottomley@SteelEye.com>, gregkh@suse.de,
       hugh@veritas.com, dmitry.torokhov@gmail.com, oneukum@suse.de,
       maneesh@in.ibm.com, rpurdie@rpsys.net, Jeff Garzik <jgarzik@pobox.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       SCSI Mailing List <linux-scsi@vger.kernel.org>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
References: <460CDBA6.5030608@gmail.com>	<1175257751.3760.19.camel@mulgrave.il.steeleye.com>	<460D12B8.6050101@gmail.com>	<1175278774.3760.44.camel@mulgrave.il.steeleye.com>	<20070401195943.GA29627@htj.dyndns.org>	<20070402112048.047867c1@gondolin.boeblingen.de.ibm.com> <20070402173443.0a3b5c51@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070402173443.0a3b5c51@gondolin.boeblingen.de.ibm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Mon, 2 Apr 2007 11:20:48 +0200,
> Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> 
>> Cool. However, there's something fishy there (not sure whether it's in
>> your patch or a latent bug in the ccw bus code that just has been
>> uncovered):
> 
> Similar bug when loading/unloading a module that creates a driver
> attribute. The winner seems to be kfree(sd->s_element) in
> release_sysfs_dirent() (in case of an attribute, it will point to the
> attribute structure, which is usually statically created)...

Thanks for finding it out.  I was suspecting that last minute change.
The code should be

if (dir node)
	kfree(s_element)
else if (symlink node)
	do things and kfree()

Thanks.

-- 
tejun
