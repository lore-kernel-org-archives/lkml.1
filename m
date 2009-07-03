Return-Path: <linux-kernel-owner+w=401wt.eu-S1757911AbZGCSiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbZGCSiM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 14:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756684AbZGCSh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 14:37:58 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49008 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756638AbZGCSh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 14:37:57 -0400
Subject: Re: [PATCH] integrity: add ima_counts_put (updated)
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: hooanon05@yahoo.co.jp
Cc: linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <7465.1246593761@jrobl>
References: <1246029874-6860-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1246039527.4809.18.camel@dyn9002018117.watson.ibm.com>
	 <12000.1246284749@jrobl>
	 <1246286783.4054.56.camel@dyn9002018117.watson.ibm.com>
	 <7959.1246307789@jrobl>
	 <1246313060.3280.81.camel@dyn9002018117.watson.ibm.com>
	 <7465.1246593761@jrobl>
Content-Type: text/plain
Date: Fri, 03 Jul 2009 14:37:59 -0400
Message-Id: <1246646279.3844.16.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-03 at 13:02 +0900, hooanon05@yahoo.co.jp wrote:
> Mimi Zohar:
> > NFSv3 is an interesting example. Permission checking is done once,
> > followed by multiple open/read/close calls. Incrementing the counters in
> > nfsd_permission() once and decrementing the counters in close, multiple
> > times, resulted in imbalance messages.  True, the solution in this case
> > was to increment in open and decrement in close, but that was only part
> > of the solution.  The other part of the solution, the important part,
> > was to add a call to ima_path_check() to measure the file.
> 
> Let me make sure.
> Does "that was only part of the solution" mean IMA does not work for
> NFSD fully? To make IMA work fully, is incrementing before open
> absolutely necessary?
> 
> J. R. Okajima

The patch is fine.  It adds a call to ima_path_check() in
nfsd_permission(), but delays incrementing the counters to nfsd_open()
and decrementing the counters to nfsd_close() in order for the counters
to be balanced.

Mimi

