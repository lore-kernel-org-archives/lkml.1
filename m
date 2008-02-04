Return-Path: <linux-kernel-owner+w=401wt.eu-S1758158AbYBDXGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158AbYBDXGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 18:06:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755296AbYBDXGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 18:06:47 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51164 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753891AbYBDXGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 18:06:46 -0500
Date: Mon, 4 Feb 2008 15:06:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: yi.y.yang@intel.com, greg@kroah.com, rdunlap@xenotime.net,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-mm1: module params broken
Message-Id: <20080204150638.512f46ea.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0802042140250.8210@blonde.site>
References: <20080203171634.58ab668b.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0802042140250.8210@blonde.site>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2008 21:56:54 +0000 (GMT)
Hugh Dickins <hugh@veritas.com> wrote:

> Please chuck out:
> add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them.patch
> (along with Randy's perfectly reasonable -fix.patch).
> 
> So predictable that it would just disable loading modules with params:
> Feb  4 13:17:02 blonde kernel: thinkpad_acpi: `1' invalid for parameter `experimental'
> 
> Maybe it's something as simple as a trailing whitespace issue,
> I haven't looked, would prefer the originator to do so.
> openSUSE 10.3 if that makes any difference.
> 

Takashi found a bug in it:

--- a/lib/vsprintf.c~add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2
+++ a/lib/vsprintf.c
@@ -234,7 +234,7 @@ int strict_strto##type(const char *cp, u
 		if (ret != 0)						\
 			*res = -(*res);					\
 	} else								\
-		ret = strict_strtou##type(cp+1, base, res);		\
+		ret = strict_strtou##type(cp, base, res);		\
 									\
 	return ret;							\
 }									\
_

and I was very bad and didn't immediately prepare and upload the fix and
hence probably wasted a lot of your time, for which I apologise.  In my
defense, it was 4:00AM Sunday and I had lost eye control by then.

Does that fix fix it?  If not: patch overboard.
