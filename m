Return-Path: <linux-kernel-owner+w=401wt.eu-S932825AbXCGFR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825AbXCGFR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 00:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932838AbXCGFR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 00:17:59 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:37165 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932825AbXCGFR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 00:17:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AHcSMRgy0f5QcrhJXFmWTxon+r4U4Bc2Xlem4WC2pCDx7SCNIodE1iL4Mf9w0tyPKfvPsv1j3jk3VnjfzQX1qwMz3KLFD637xzbHDzMbJx+4p92RN32+mVhdaW3bpEZrQe5LXI6ZNB/ZdqIWyAe+NgO2KNWedUIlk9YZNQMqTbw=
Message-ID: <4e5ebad50703062117j5a6866d9x8580060ae0f83a94@mail.gmail.com>
Date: Wed, 7 Mar 2007 13:17:57 +0800
From: "Sonic Zhang" <sonic.adi@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] Blackfin: blackfin i2c driver
Cc: bryan.wu@analog.com, khali@linux-fr.org, linux-kernel@vger.kernel.org,
       mhfan@ustc.edu
In-Reply-To: <20070305231846.d4a31502.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1173164058.31825.16.camel@roc-desktop>
	 <20070305231846.d4a31502.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/6/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 06 Mar 2007 14:54:18 +0800 "Wu, Bryan" <bryan.wu@analog.com> wrote:
>
> > Hi folks,
> >
> > [PATCH] Blackfin: blackfin i2c driver
> >

> > +     struct i2c_msg *pmsg;
> > +     int i, ret;
> > +     int rc = 0;
> > +
> > +     if (!(bfin_read_TWI_CONTROL() & TWI_ENA))
> > +             return -ENXIO;
> > +
> > +     down(&iface->twi_lock);
> > +
> > +     while (bfin_read_TWI_MASTER_STAT() & BUSBUSY) {
> > +             up(&iface->twi_lock);
> > +             schedule();
> > +             down(&iface->twi_lock);
> > +     }
>
> That's a busy loop until this task's timeslice has expired.  It'll work,
> but it'll suck a bit.  (Repeated in several places)
>

OK, I change it into yield(). So, current process will be move to the
tail of the run queue. Is that OK with you?
