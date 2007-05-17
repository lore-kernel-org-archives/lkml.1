Return-Path: <linux-kernel-owner+w=401wt.eu-S1763046AbXEQA7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763046AbXEQA7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 20:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762052AbXEQA6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 20:58:48 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:34550 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761091AbXEQA6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 20:58:46 -0400
X-Sasl-enc: FlibU3J7DiMD/uMK+B2d/TKy/t5d4MrmmWT67BJ6aJS7 1179363526
Date: Wed, 16 May 2007 21:58:42 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Rob Landley <rob@landley.net>
Cc: Tejun Heo <htejun@gmail.com>, Dave Jones <davej@redhat.com>,
       Francesco Pretto <ceztko@gmail.com>, Phillip Susi <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
Message-ID: <20070517005842.GC600@khazad-dum.debian.net>
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no> <200705160129.16048.rob@landley.net> <464AEDD0.3090304@gmail.com> <200705161948.56497.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705161948.56497.rob@landley.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007, Rob Landley wrote:
> Ok, so the change is to get shutdown to _stop_ doing something stupid 
> (spinning down the disk without first flushing the cache), and the correct 
> thing for shutdown to do is keep its' mitts off the thing and let the kernel 
> power down the darn hardware?

Yes, for *all* SCSI disk devices, libata or not.

But you need to detect if the kernel has proper SCSI device shutdown
support, because if it does not, you have to do a cache flush and spindown
on shutdown(8) if you can...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
