Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbXHaVyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbXHaVyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 17:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbXHaVyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 17:54:47 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:49337 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbXHaVyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 17:54:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=fd+k/+9G85cECVMiEMtRNMdVWyimMNxxOJ6ZCo+L2mmsvmcUttahyqMHliw0WtLm+boWEWPAkUAXQfIJsgGdQ+AKaI7KWZR6AvrTG3YbmC9Nt3BqfhykTOYU8ZUhm71uXsvjdZ2w+IHXni5aNiZpB+HvzNrVaOfUzYAEBPpgLb0=
Message-ID: <661de9470708311454l3aaea0d3g4555721ba84c8aba@mail.gmail.com>
Date: Sat, 1 Sep 2007 03:24:45 +0530
From: "Balbir Singh" <balbir@linux.vnet.ibm.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [-mm PATCH] Memory controller improve user interface (v2)
Cc: Linux@smtp2.linux-foundation.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linux MM Mailing List" <linux-mm@kvack.org>,
       "David Rientjes" <rientjes@google.com>,
       Containers <containers@lists.osdl.org>,
       "Paul Menage" <menage@google.com>
In-Reply-To: <20070831130216.226db806.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070830185246.3170.74806.sendpatchset@balbir-laptop>
	 <20070831130216.226db806.akpm@linux-foundation.org>
X-Google-Sender-Auth: e9276e55b64fd4e2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/1/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 31 Aug 2007 00:22:46 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
> > +/*
> > + * Strategy routines for formating read/write data
> > + */
> > +int mem_container_read_strategy(unsigned long long val, char *buf)
> > +{
> > +     return sprintf(buf, "%llu Bytes\n", val);
> > +}
>
> It's a bit cheesy to be printing the units like this.  It's better to just
> print the raw number.
>
> If you really want to remind the user what units that number is in (not a
> bad idea) then it can be encoded in the filename, like
> /proc/sys/vm/min_free_kbytes, /proc/sys/vm/dirty_expire_centisecs, etc.
>

Sounds good, I'll change the file to memory.limit_in_bytes and
memory.usage_in_bytes.

>
> > +int mem_container_write_strategy(char *buf, unsigned long long *tmp)
> > +{
> > +     *tmp = memparse(buf, &buf);
> > +     if (*buf != '\0')
> > +             return -EINVAL;
> > +
> > +     printk("tmp is %llu\n", *tmp);
>
> don't think we want that.
>

Yes, I'll redo the patch and resend.

> > +     /*
> > +      * Round up the value to the closest page size
> > +      */
> > +     *tmp = ((*tmp + PAGE_SIZE - 1) >> PAGE_SHIFT) << PAGE_SHIFT;
> > +     return 0;
> > +}

Thanks,
Balbir
