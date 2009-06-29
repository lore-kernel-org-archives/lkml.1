Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbZF2WEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbZF2WEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 18:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbZF2WE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 18:04:28 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:54980 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbZF2WE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 18:04:27 -0400
Subject: Re: [PATCH] integrity: add ima_counts_put (updated)
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: hooanon05@yahoo.co.jp
Cc: linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <7959.1246307789@jrobl>
References: <1246029874-6860-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1246039527.4809.18.camel@dyn9002018117.watson.ibm.com>
	 <12000.1246284749@jrobl>
	 <1246286783.4054.56.camel@dyn9002018117.watson.ibm.com>
	 <7959.1246307789@jrobl>
Content-Type: text/plain
Date: Mon, 29 Jun 2009 18:04:20 -0400
Message-Id: <1246313060.3280.81.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-30 at 05:36 +0900, hooanon05@yahoo.co.jp wrote:
> Mimi Zohar:
> > This suggestion has been mentioned before; and yes would definitely
> > resolve the annoying imbalance and iint_free() messages.  But
> > incrementing/decrementing the pointers automatically each time a file is
> > opened/closed would defeat their purpose - alerting us that a file was
> > possibly not measured before being read/executed. 
> 
> I may be wrong since I don't fully understand IMA's purpose, but why did
> you create ima_counts_get() and make it call after dentry_open() in
> nfsd_open()? Isn't it same thing essentially?
> 
> 
> J. R. Okajima

NFSv3 is an interesting example. Permission checking is done once,
followed by multiple open/read/close calls. Incrementing the counters in
nfsd_permission() once and decrementing the counters in close, multiple
times, resulted in imbalance messages.  True, the solution in this case
was to increment in open and decrement in close, but that was only part
of the solution.  The other part of the solution, the important part,
was to add a call to ima_path_check() to measure the file.

The imbalance message did what it was suppose to do - highlight the fact
that a file was read/executed without first being measured.

Mimi

