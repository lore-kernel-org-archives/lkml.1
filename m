Return-Path: <linux-kernel-owner+w=401wt.eu-S1760236AbXKHJei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236AbXKHJei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 04:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbXKHJeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 04:34:31 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:4547 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450AbXKHJea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 04:34:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=LmdpovwKVyIcitAHu++BrvzV2Zo5zqwBdddguOGqUz1dAGOUQZo85spO7hfmyN9oeH6t4TArHmD0/PmNimu0ZqFdWdq0XvTMEaCJzwv+FJgvOdtahefdmg+MydnCfZTOTTCqyYAFVMYMMbCGW7S5gPbHCbzOmmePF4SWiaPy9RY=
Message-ID: <4732D817.2060300@gmail.com>
Date: Thu, 08 Nov 2007 18:34:15 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: balagi@justmail.de
CC: Peter Osterlund <petero2@telia.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, gregkh@suse.de
Subject: Re: pktcdvd oops
References: <E1Iq3NN-00049L-8x@www16.emo.freenet-rz.de>
In-Reply-To: <E1Iq3NN-00049L-8x@www16.emo.freenet-rz.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

balagi@justmail.de wrote:
> Hello,
> 
> tested it too, running linux 2.6.23 in a qemu instance, and the patch worked.
> But i would prefer to take the try_module_get() stuff into pkt_setup_dev() because
> it is used also in the older procfs interface. Can we run into the same problem here, means
> procfs holds no module references too, like sysfs now?

procfs should be okay.  sysfs was too intertwined with driver model and
module reference counting never worked well.  We had to pull module
reference counting out of there.

> Maybe also the "/sys/class/pktcdvd/remove" command should be wrapped with an
> try_module_get() ???

No, I don't think so.  The code won't go away beneath it.  After
module_put() the module can die (ie. calling __module_get() on it will
trigger BUG) but it won't go away till the function finishes.

Thanks.

-- 
tejun
