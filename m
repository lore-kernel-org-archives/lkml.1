Return-Path: <linux-kernel-owner+w=401wt.eu-S1758432AbZBCAd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432AbZBCAd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 19:33:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbZBCAdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 19:33:50 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:38498 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbZBCAdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 19:33:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HKlKvtr3DfKhZEqrig4Ye+EYD44d+LgyaVIWuGckxhpfKAJfzWUsBHmSSjNTLVMrJc
         NFDd/KJ9Xwk55SWIfyJnDso7LJfNzHRWwOc6izr0mQcy0Ut/HTNVd0dV9wSmjEnxgNa6
         si4UyTsMb/eC+V8Ja2Ep8FyrFY9szrPYOMYKE=
Date: Tue, 3 Feb 2009 03:33:45 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balaji Rao <balajirrao@openmoko.org>, linux-kernel@vger.kernel.org,
       cbou@mail.ru, andy@openmoko.com
Subject: Re: [PATCH 3/3] pcf50633_charger: Enable periodic charging restart
Message-ID: <20090203003345.GB29462@zarina>
Reply-To: cbouatmailru@gmail.com
References: <20090127135238.6875.26314.stgit@fedora.yogi> <20090127135312.6875.94604.stgit@fedora.yogi> <20090202144131.41a8d279.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20090202144131.41a8d279.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 02, 2009 at 02:41:31PM -0800, Andrew Morton wrote:
> On Tue, 27 Jan 2009 19:23:12 +0530
> Balaji Rao <balajirrao@openmoko.org> wrote:
> 
> > @@ -157,6 +213,7 @@ pcf50633_mbc_irq_handler(int irq, void *data)
> >  		mbc->usb_online = 0;
> >  		mbc->usb_active = 0;
> >  		pcf50633_mbc_usb_curlim_set(mbc->pcf, 0);
> > +		cancel_delayed_work_sync(&mbc->charging_restart_work);
> >  	}
> 
> eek, can't call cancel_delayed_work_sync() from an interrupt handler! 

It's rather confusing, but it's not an irq handler, in the sense that
it does not run in atomic context -- the PCF IRQ handlers run in
kernel threads.

It's done that way because PCF50633 is an I2C device, and normally
we can't access I2C devices in the atomic context (plus it's rather
slow, thus would cause huge latencies if we'd try).

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
