Return-Path: <linux-kernel-owner+w=401wt.eu-S1761522AbXGJAya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761522AbXGJAya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 20:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760253AbXGJAyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 20:54:20 -0400
Received: from ms-smtp-06.texas.rr.com ([24.93.47.45]:61597 "EHLO
	ms-smtp-06.texas.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759750AbXGJAyT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 20:54:19 -0400
From: Dave McCracken <dave.mccracken@oracle.com>
Organization: Oracle Corp
To: akpm@linux-foundation.org
Subject: Re: [PATCH] include private data mappings in RLIMIT_DATA limit
Date: Mon, 9 Jul 2007 19:54:10 -0500
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <4692D616.4010004@oracle.com>
In-Reply-To: <4692D616.4010004@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707091954.10502.dave.mccracken@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 July 2007, Herbert van den Bergh wrote:
> With this patch, not only memory in the data segment of a process, but
> also private data mappings, both file-based and anonymous, are counted
> toward the RLIMIT_DATA resource limit.  Executable mappings, such as
> text segments of shared objects, are not counted toward the private data
> limit.  The result is that malloc() will fail once the combined size of
> the data segment and private data mappings reaches this limit.
>
> This brings the Linux behavior in line with what is documented in the
> POSIX man page for setrlimit(3p).

I believe this patch is a simple and obvious fix to a hole introduced when 
libc malloc() began using mmap() instead of brk().  We took away the ability 
to control how much data space processes could soak up.  This patch returns 
that control to the user.

Dave McCracken
