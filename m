Return-Path: <linux-kernel-owner+w=401wt.eu-S965126AbXHJSqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965126AbXHJSqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 14:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762577AbXHJSqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 14:46:39 -0400
Received: from smtp23.orange.fr ([80.12.242.97]:63241 "EHLO smtp23.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759831AbXHJSqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 14:46:38 -0400
X-Greylist: delayed 14516 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Aug 2007 14:46:37 EDT
X-ME-UUID: 20070810144439399.619031C00087@mwinf2344.orange.fr
Subject: Re: Noatime vs relatime
From: Xavier Bestel <xavier.bestel@free.fr>
To: Vlad <vladc6@yahoo.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <233939.75965.qm@web54403.mail.yahoo.com>
References: <233939.75965.qm@web54403.mail.yahoo.com>
Content-Type: text/plain
Date: Fri, 10 Aug 2007 16:44:35 +0200
Message-Id: <1186757075.17619.32.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-10 at 07:26 -0700, Vlad wrote:
> Relatime seems to be wasteful of both IO resources _and_ CPU cycles.
> Instead of performing a single IO operation (as atime does), relatime
> performs at least three IO operations and three CPU-dependent
> operations:
> 
> 1) a read IO operation to find out the old atime
> 2) a read IO operation to find out the old ctime
> 3) a read IO operation to find out the old mtime
> 4) Comparison of "old atime is <= than mtime/ctime"
> 5) Find out current time
> 6) Comparison of "current time minus old atime is > X"

As all [acm]times are stored in the same block (inode), I bet all this
is one single IO, plus some insignificant computation (3 comparisons
plus reading time is really smaller than one block IO).

	Xav


