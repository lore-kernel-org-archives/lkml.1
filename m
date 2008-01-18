Return-Path: <linux-kernel-owner+w=401wt.eu-S1760473AbYARKfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760473AbYARKfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 05:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760818AbYARKe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 05:34:58 -0500
Received: from wx-out-0506.google.com ([66.249.82.238]:34394 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760387AbYARKe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 05:34:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sLeZkBVlVX6snXjJY3XOYCa2aAWBikYQXTXl2j3fClZl+H7ytGEgSzc2Tj2DWJ3ZwjgsEfFNU9LKf9Thn+ADK9j9GAFUO7hNHgxZl7e1JCV1LNEuMhU8G3ml1rp62Tuc252UzyWQta6n+66U5HBUofA/kWFFpRFJZ2lVthLubRQ=
Message-ID: <a8e1da0801180234k4b48fd1axaba6d7d334219430@mail.gmail.com>
Date: Fri, 18 Jan 2008 18:34:55 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Cornelia Huck" <cornelia.huck@de.ibm.com>
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
Cc: "Gabor Gombas" <gombasg@sztaki.hu>, "Tejun Heo" <htejun@gmail.com>,
       "Al Viro" <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net, kay.sievers@vrfy.org,
       "Greg KH" <greg@kroah.com>, "Marcel Holtmann" <marcel@holtmann.org>,
       davem@davemloft.net
In-Reply-To: <20080118112337.0b457c49@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080108133215.GA15814@boogie.lpds.sztaki.hu>
	 <20080115015741.GB2780@darkstar.te-china.tietoenator.com>
	 <20080116010205.GA2970@darkstar.te-china.tietoenator.com>
	 <20080116230646.GB6715@boogie.lpds.sztaki.hu>
	 <a8e1da0801162324r2cd82684iede3fc8c2f8c391c@mail.gmail.com>
	 <20080117081504.GA3123@darkstar.te-china.tietoenator.com>
	 <20080117124259.19a88129@gondolin.boeblingen.de.ibm.com>
	 <a8e1da0801171937r92a1c32l116315a76f334776@mail.gmail.com>
	 <20080118101933.258bfae9@gondolin.boeblingen.de.ibm.com>
	 <20080118112337.0b457c49@gondolin.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 18, 2008 6:23 PM, Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> On Fri, 18 Jan 2008 10:19:33 +0100,
> Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
>
> > >
> > > 1314         if (IS_ERR(new_parent_kobj)) {
> > > 1315                 error = PTR_ERR(new_parent_kobj);
> > > 1316                 put_device(new_parent);
> > > 1317                 goto out;
> > > 1318         }
> > > 1319         pr_debug("DEVICE: moving '%s' to '%s'\n", dev->bus_id,
> > > 1320                  new_parent ? new_parent->bus_id : "<NULL>");
> > > 1321         error = kobject_move(&dev->kobj, new_parent_kobj);
> > > 1322         if (error) {
> > > 1323                 put_device(new_parent);
> > >
> > > imagine new_parent is NULL, then the new_parent_kobj should be put
> >
> > No, we would need a put_device_parent() (crappy name) which puts the
> > reference iff get_device_parent() grabbed it.
>
> And looking at Greg's patchset, it has cleanup_device_parent(), which
> does just that. But it is only called in device_del(), not when
> device_move() has errors.
>
> (get_device_parent() also always returns a pointer to a kobject or
> NULL, so we can get rid of those IS_ERR() checks in setup_parent() and
> device_move() as well.)
>

Hmm, thanks.
I will be offline during weekend,  but I will still check the
device_move and other code if I have time.
