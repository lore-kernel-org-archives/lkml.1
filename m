Return-Path: <linux-kernel-owner+w=401wt.eu-S1752502AbZIEQST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbZIEQST (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 12:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbZIEQSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 12:18:18 -0400
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:58307 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751160AbZIEQSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 12:18:17 -0400
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Jamie Lokier <jamie@shareable.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz
In-Reply-To: <20090905132653.GH24516@shareable.org>
References: <1252050406-22467-1-git-send-email-jens.axboe@oracle.com>
	 <1252050406-22467-9-git-send-email-jens.axboe@oracle.com>
	 <4AA13232.5000309@rsk.demon.co.uk>  <20090905132653.GH24516@shareable.org>
Content-Type: text/plain
Date: Sat, 05 Sep 2009 17:18:16 +0100
Message-Id: <1252167496.2291.15.camel@castor>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-05 at 14:26 +0100, Jamie Lokier wrote:
> Richard Kennedy wrote:
> > I've been testing this & it works pretty well here, but setting 
> > max_writeback_mb to 128 seems much too large for normal desktop machines.
> > 
> > Because it is so large the background writes don't stop when they get 
> > down to the background threshold, but just keep on writing. 
> > background_threshold on my machine is only about 300Mb so it can 
> > undershoot by quite a bit. This could impact random write workloads 
> > significantly.
> 
> If that's true, would it be even worse for embedded devices with, say,
> just 32MB RAM?  It sounds like writeback undershoot might be rather
> extreme in that case.

Well, on a machine that small I don't think it will be any worse. The
current code tries to write 1024 pages so its undershoot will be about
100% anyway. 

> Also on this topic, should max_writeback be smaller for slow disks?  I
> have a small device here with a hard disk that can only be written at
> 2-10MB/s due to limitations of the built-in IDE controller.
> 
> I know that's unusual, but it shows there is quite a wide range of
> speeds at which disks can be written, even just counting hard disks.
> 
> -- Jamie

I'm not sure about that, it will depend on how the background threshold
issue gets fixed.

regards
Richard
 

