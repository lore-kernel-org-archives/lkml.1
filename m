Return-Path: <linux-kernel-owner+w=401wt.eu-S1760843AbXHBXml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760843AbXHBXml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 19:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756444AbXHBXmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 19:42:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756124AbXHBXmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 19:42:33 -0400
Date: Thu, 2 Aug 2007 19:42:29 -0400
From: Jakub Jelinek <jakub@redhat.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: gcc fixed size char array initialization bug - known?
Message-ID: <20070802234229.GU2063@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0708022141420.6774@poirot.grange>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 09:55:51PM +0200, Guennadi Liakhovetski wrote:
> I've run across the following gcc "feature":
> 
> 	char c[4] = "01234";
> 
> gcc emits a nice warning
> 
> warning: initializer-string for array of chars is too long
> 
> But do a
> 
> 	char c[4] = "0123";
> 
> and - a wonder - no warning. No warning with gcc 3.3.2, 3.3.5, 3.4.5, 
> 4.1.2. I was told 4.2.x does produce a warning.

4.2.x nor 4.3 doesn't warn either and it is correct not to warn about
perfectly valid code.
ISO C99 is very obvious in that the terminating '\0' (resp. L'\0') from
the string literal is only added if there is room in the array or if the
array has unknown size.

	Jakub
