Return-Path: <linux-kernel-owner+w=401wt.eu-S1761747AbXHBVJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761747AbXHBVJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 17:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761823AbXHBVJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 17:09:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38881 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761663AbXHBVJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 17:09:03 -0400
Date: Thu, 2 Aug 2007 22:09:02 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: gcc fixed size char array initialization bug - known?
Message-ID: <20070802210902.GQ21089@ftp.linux.org.uk>
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange> <20070802200856.GO21089@ftp.linux.org.uk> <Pine.LNX.4.60.0708022223190.6774@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0708022223190.6774@poirot.grange>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 10:26:37PM +0200, Guennadi Liakhovetski wrote:
> 
> Worse yet, K&R explicitely writes:
> 
> <quote>
> 
> 	char pattern[] = "ould";
> 
> is a shorthand for the longer but equivalent
> 
> 	char pattern[] = { 'o', 'u', 'l', 'd', '\0' };
> 
> </quote>
> 
> In the latter spelling gcc < 4.2 DOES warn too.

Does warn for what?  Array with known size?  Sure, so it should - you
have excess initializer list elements.

Note the [] in the quoted - it does matter.

Again, it's perfectly legitimate to use string literal to initialize
any kind of array of character type.  \0 goes there only if there's
space for it; if array size is unknown, the space is left.  That's it.
