Return-Path: <linux-kernel-owner+w=401wt.eu-S1759153AbYEOLR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759153AbYEOLR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 07:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbYEOLRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 07:17:48 -0400
Received: from ozlabs.org ([203.10.76.45]:58803 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947AbYEOLRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 07:17:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18476.5290.709729.582063@cargo.ozlabs.ibm.com>
Date: Thu, 15 May 2008 20:47:06 +1000
From: Paul Mackerras <paulus@samba.org>
To: Carl Love <cel@us.ibm.com>
Cc: linuxppc-dev <linuxppc-dev@ozlabs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Maynard Johnson <maynardj@us.ibm.com>
Subject: Re: [PATCH] Fix for OProfile callgraph for Power 64 bit user apps
In-Reply-To: <1210183924.7726.28.camel@carll-linux-desktop>
References: <1210183924.7726.28.camel@carll-linux-desktop>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carl Love writes:

> The following patch fixes the 64 bit user code backtrace 
> which currently may hang the system.  

What exactly is wrong with it?

Having now taken a much closer look, I now don't think Nate Case's
patch addresses this, since it only affects constant size arguments
<= 8 to copy_{to,from}_user_inatomic.

However, I don't see why your patch fixes anything.  It means we do
two access_ok calls and two __copy_from_user_inatomic calls, for 8
bytes, at sp and at sp + 16, rather than doing one access_ok and
__copy_from_user_inatomic for 24 bytes at sp.  Why does that make any
difference (apart from being slower)?

Paul.
