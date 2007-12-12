Return-Path: <linux-kernel-owner+w=401wt.eu-S1757108AbXLLSjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbXLLSjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 13:39:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbXLLSjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 13:39:36 -0500
Received: from ns.firmix.at ([62.141.48.66]:2659 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754252AbXLLSjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 13:39:35 -0500
Subject: Re: A peek at the future of storage
From: Bernd Petrovitsch <bernd@firmix.at>
To: Daniel Phillips <phillips@phunq.net>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200712121002.44643.phillips@phunq.net>
References: <200712120846.18320.phillips@phunq.net>
	 <20071212174613.GA16656@fieldses.org>
	 <200712121002.44643.phillips@phunq.net>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Wed, 12 Dec 2007 19:39:25 +0100
Message-Id: <1197484765.32283.106.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.327 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.327 required=5
X-Spam-Score: -2.327 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mit, 2007-12-12 at 10:02 -0800, Daniel Phillips wrote:
> On Wednesday 12 December 2007 09:46, J. Bruce Fields wrote:
[...]
> > People have proposed writing a daemon that just reads
> > /proc/net/rpc/nfsd periodically and uses that to adjust the number of
> > threads from userspace, probably subject to some limits in a config
> > file someplace. (Think that could do the job, or is there some reason
[...]
> So how would a userspace daemon know that kernel is blocking and new 
> threads are needed?  In kernel this is pretty easy: when a new request 
> arrives, look on the thread list and if none are available, generate a 
> new one.  Something special needs to be done to handle the case where 
> there are no threads available because they are all piled up on a 
> semaphore due to, for example, somebody unplugging the network cable 
> for a remote disk.  We have to avoid generating infinite threads in 
> that case.  Ideas?

Add a sysctl configurable maximum number of NFS threads and default it
to 8 (or whatever now the default value is).
And one wants probably some logic to kill them again if they are not
used long enough. And then you need/want another variable for the
minimum number of NFS threads around.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


