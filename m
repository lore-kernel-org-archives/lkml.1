Return-Path: <linux-kernel-owner+w=401wt.eu-S1758728AbZALW02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728AbZALW02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758571AbZALWZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:25:42 -0500
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:38325
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758557AbZALWZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:25:41 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkQBANBRa0l8qMTI/2dsb2JhbAAI0nSFbw
X-IronPort-AV: E=Sophos;i="4.37,255,1231081200"; 
   d="scan'208";a="300032915"
Subject: Re: How to access a regular file from within a module ?
From: Ben Nizette <bn@niasdigital.com>
To: joseluismarchetti@yahoo.com.br
Cc: Robert Hancock <hancockr@shaw.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <113881.9018.qm@web34408.mail.mud.yahoo.com>
References: <113881.9018.qm@web34408.mail.mud.yahoo.com>
Content-Type: text/plain
Date: Tue, 13 Jan 2009 09:25:40 +1100
Message-Id: <1231799141.2714.24.camel@linux-51e8.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-12 at 07:51 -0800, Jose Luis Marchetti wrote:

> OK, that is clear now.
> From all I read, it is possible to access files from within inside the kernel, but it would not be a good practice, thanks for the insights.
> > 

I don't know why no-one's brought this up already but no, it usually
isn't even possible.  As previously mentioned, you will hijack the
current user context to do your file operations.  That context may be in
a different filesystem namespace (eg due to chroot'ing) and as such
*won't even be able to see the file you're trying to hit*.

Even if you create a new kernel thread which is parented to init you'll
get a consistent view of files but it's still very hard to know it's the
*right* view of files.

http://kernelnewbies.org/FAQ/WhyWritingFilesFromKernelIsBad

	--Ben.


