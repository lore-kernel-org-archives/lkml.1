Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbYLWWiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbYLWWiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 17:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbYLWWhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 17:37:51 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:36258 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbYLWWhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 17:37:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fOke2v78RvqEl4P66CPyqP1j48k9u5BsBARuyFc7gJn67JHC7DyumtX/HXMd4H1o33
         nzumWVyBgHILT3rtgS09O0x4QAcD8/Cmqii/3+vuoAXIpASJh6tKaClebBB4T9lGzPex
         BE0KrgDhpdk91KNnqVr0VAidBIaacFD9lpGgs=
Message-ID: <961aa3350812231437x4debaf9byf230a63582561010@mail.gmail.com>
Date: Wed, 24 Dec 2008 07:37:48 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Josef Bacik" <jbacik@redhat.com>
Subject: Re: [PATCH] ext4: annotate unhandled kmem_cache_alloc() error
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Theodore Tso" <tytso@mit.edu>, adilger@sun.com,
       linux-ext4@vger.kernel.org
In-Reply-To: <20081223142915.GA23303@unused.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081223104016.GC7217@localhost.localdomain>
	 <20081223142915.GA23303@unused.rdu.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> BUG_ON is good for devel things, but for stable stuff it's better to let
> somebody know an error occured rather than panic'ing the box.  The proper
> solution would be to do
>
> if (!new_entry)
>        return -ENOMEM;
>
> or if there is some out: label set ret to -ENOMEM and goto out, whatever is
> appropriate in the context.  Thanks,

I don't understand the code around here well.
But I think it is not that simple.

The "new_entry" is needed to free blocks. If it just returns error,
it leaks something.
