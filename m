Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbZLWNQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbZLWNQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 08:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbZLWNQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 08:16:27 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:42674 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbZLWNQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 08:16:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=T7QZOeR1FTfxlBhbp/XzcluIxiVc/ezM0dIfCLNk13dklElFMTDvDzKLn/0siLKR6D
         Zb4s+/w7FnJhr8O8A4dfLewnLHWtifU5hF4xtCDvMM0HqOSjyoM1VUH4IPFYBVL4ofd5
         hIRRXRjoErRdF5VIarmPGxfuazPVfMLGCiFcw=
Date: Wed, 23 Dec 2009 15:15:52 +0200
From: Dan Carpenter <error27@gmail.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org
Subject: double unlock in rng_dev_read()
Message-ID: <20091223131552.GA17923@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems like we unlock rng_mutex twice (2.6.33-rc1).

drivers/char/hw_random/core.c
   151                  mutex_unlock(&rng_mutex);
   152
   153                  if (need_resched())
   154                          schedule_timeout_interruptible(1);
   155
   156                  if (signal_pending(current)) {
   157                          err = -ERESTARTSYS;
   158                          goto out;
   159                  }
   160          }
   161  out_unlock:
   162          mutex_unlock(&rng_mutex);
 
regards,
dan carpenter
