Return-Path: <linux-kernel-owner+w=401wt.eu-S1763133AbXEPXtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763133AbXEPXtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 19:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757189AbXEPXtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 19:49:16 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:41239
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756415AbXEPXtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 19:49:15 -0400
From: Rob Landley <rob@landley.net>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
Date: Wed, 16 May 2007 19:48:56 -0400
User-Agent: KMail/1.9.1
Cc: Dave Jones <davej@redhat.com>, Francesco Pretto <ceztko@gmail.com>,
       Phillip Susi <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no> <200705160129.16048.rob@landley.net> <464AEDD0.3090304@gmail.com>
In-Reply-To: <464AEDD0.3090304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705161948.56497.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 May 2007 7:41 am, Tejun Heo wrote:
> Hello,
> 
> Rob Landley wrote:
> > Um, hang on.  So libata can't reliably turn the system off without data 
loss 
> > and potential damage to hardware unless userspace goes through a special 
song 
> > and dance?  And this is _not_ considered a defect in the kernel?
> 
> Yeap, definitely a bug in the kernel and we're trying to fix it.  Just
> for the record, we have _always_ issued FLUSH CACHE, so there hasn't
> been and won't be any data loss problem.  The data loss problem was
> mentioned as why we can't do things completely inside kernel without
> updating userland shutdown(8) which issues STANDBYNOW.

Ok, so the change is to get shutdown to _stop_ doing something stupid 
(spinning down the disk without first flushing the cache), and the correct 
thing for shutdown to do is keep its' mitts off the thing and let the kernel 
power down the darn hardware?

Woot,

Rob
