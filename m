Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbZBWHVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbZBWHVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 02:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbZBWHVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 02:21:13 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:37850 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbZBWHVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 02:21:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=wdDfRiSUYa5mv6UKwAERvX066Wm0EMTUbz3Y3nXVCyMO9PtBe1+ad/yt1A2DlqyEiW
         0SpKQhOYAFn9vTzklxRGJfK0QfLAp+uOSwa7y9e+5Vb2tULxkjlN9L7O07OWI8iiGd7b
         GoPFMbRDILk+dF+MSeiMh8VnIhdnCLuG/aELg=
MIME-Version: 1.0
In-Reply-To: <1235344649-18265-12-git-send-email-mel@csn.ul.ie>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
	 <1235344649-18265-12-git-send-email-mel@csn.ul.ie>
Date: Mon, 23 Feb 2009 09:21:09 +0200
X-Google-Sender-Auth: 7f805ebf10e1d650
Message-ID: <84144f020902222321q12f54ed8wae3865064bb6e43@mail.gmail.com>
Subject: Re: [PATCH 11/20] Inline get_page_from_freelist() in the fast-path
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 1:17 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> In the best-case scenario, use an inlined version of
> get_page_from_freelist(). This increases the size of the text but avoids
> time spent pushing arguments onto the stack.
>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

It's not obvious to me why this would be a huge win so I suppose this
patch description could use numbers. Note: we used to do tricks like
these in slab.c but got rid of most of them to reduce kernel text size
which is probably why the patch seems bit backwards to me.
