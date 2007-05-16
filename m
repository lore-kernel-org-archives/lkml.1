Return-Path: <linux-kernel-owner+w=401wt.eu-S1762630AbXEPMg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762630AbXEPMg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 08:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758324AbXEPMgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 08:36:47 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:30284 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758274AbXEPMgp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 08:36:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=YP0UM8nilEtPmegIEQw8KuQdbtp7RpxOoAOqu+89iKq80gKltq3t/SObLwHHif3QaoW1+VtSAmgxxlV+Hzcef8F1yy94O3uQ96h2coYAsaKNCo8AF5ciMfdVMz56Q48V3kacuUPuJNmGQ+ZCqcn/xXXBJZeanjGSppfAzTfTrvY=
Message-ID: <84144f020705160536i189f6206sffc964a145177da7@mail.gmail.com>
Date: Wed, 16 May 2007 15:36:44 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@lazybastard.org>
Subject: Re: [PATCH] LogFS take three
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       "Albert Cahalan" <acahalan@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>, "Greg KH" <greg@kroah.com>,
       "Ingo Oeser" <ioe-lkml@rameria.de>
In-Reply-To: <20070516122603.GE5472@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20070515151919.GA32510@lazybastard.org>
	 <Pine.LNX.4.64.0705161319060.5152@sbz-30.cs.Helsinki.FI>
	 <20070516122603.GE5472@lazybastard.org>
X-Google-Sender-Auth: b89547eddcd2d14d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/16/07, Jörn Engel <joern@lazybastard.org> wrote:
> > > +/* FIXME: all this mess should get replaced by using the page cache */
> > > +static void fixup_from_wbuf(struct super_block *sb, struct logfs_area
> > *area,
> > > +             void *read, u64 ofs, size_t readlen)
> > > +{
> >
> > Indeed. And I think you're getting some more trouble because of this...
>
> More trouble?

Forgot to add (see below). Seems logfs_segment_read would be simpler
too if you fixed this.

> [ Objects are the units that get compressed.  Segments can contain both
> compressed and uncompressed objects. ]
>
> It is a trade-off.  Each object has a 24 Byte header plus X Bytes of
> data.  Whether the data is compressed or not is indicated in the header.

Was my point really. Why do segments contain both compressed and
uncompressed objects?
