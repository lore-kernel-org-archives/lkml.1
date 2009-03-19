Return-Path: <linux-kernel-owner+w=401wt.eu-S1754994AbZCSPwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbZCSPwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 11:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZCSPwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 11:52:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:60505 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbZCSPv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 11:51:59 -0400
Subject: Re: Q: NFSD readdir in linux-2.6.28
From: David Woodhouse <dwmw2@infradead.org>
To: hooanon05@yahoo.co.jp
Cc: Al Viro <viro@zeniv.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
In-Reply-To: <8913.1237476890@jrobl>
References: <8036.1237474444@jrobl>
	 <1237475837.16359.106.camel@macbook.infradead.org>  <8913.1237476890@jrobl>
Content-Type: text/plain
Date: Thu, 19 Mar 2009 15:51:52 +0000
Message-Id: <1237477912.16359.109.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-20 at 00:34 +0900, hooanon05@yahoo.co.jp wrote:
> If you remember why you discarded the FS_NO_LOOKUP_IN_READDIR flag
> approach, please let me know. URL or something is enough.

I was just lamenting that decision. I think someone persuaded me that
the extra complexity wasn't worth it, and that we should just do it
unconditionally. 

One option would be to restore the FS_NO_LOOKUP_IN_READDIR flag, and
document that it means that your ->lookup is called _without_ i_mutex
held. That would actually be OK in all cases that need the flag, I
believe (since the whole point in those cases is that they have their
_own_ locking which is why we did it in the first place).

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

