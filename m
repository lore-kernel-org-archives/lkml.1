Return-Path: <linux-kernel-owner+w=401wt.eu-S1754330AbZKCS72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbZKCS72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 13:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbZKCS72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 13:59:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753248AbZKCS71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 13:59:27 -0500
Date: Tue, 3 Nov 2009 10:59:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] strstrip incorrectly marked __must_check
Message-Id: <20091103105921.160d5599.akpm@linux-foundation.org>
In-Reply-To: <1257273488.9427.27.camel@mulgrave.site>
References: <1257273488.9427.27.camel@mulgrave.site>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Nov 2009 12:38:08 -0600
James Bottomley <James.Bottomley@suse.de> wrote:

> strstrip strips whitespace from the beginning and end of a string.  I
> agree you have to take the returned pointer if you want to strip from
> the beginning.  However, if you wish to keep the whitespace at the
> beginning and only wish strstrip to remove it from the end, then it's
> entirely legitimate to discard the returned pointer.
> 
> This is what we have in drivers/scsi/ipr.c and the patch to make
> strstrip __must_check is now causing SCSI spurious warnings in that
> code.
> 

Would prefer to keep the warning and to patch ipr.c, please.  We found
I think three call sites which were incorrectly ignoring the strstrip()
return value and it's reasonable to fear that others will make the same
mistake in the future.

And maybe ipr.c _should_ be patched.  Right now it's assuming that the
string coming back from the device has no leading whitespace.  Why trim
any possible trailing whitespace but not trim any possible leading
whitespace?

Or..

/*
 * Comment goes here
 */
static inline void strsrip_tail(char *str)
{
	char *x __used;
	x = strstrip(str);
}
