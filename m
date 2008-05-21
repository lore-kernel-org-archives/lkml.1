Return-Path: <linux-kernel-owner+w=401wt.eu-S932904AbYEUAp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904AbYEUAp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757547AbYEUApu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:45:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41587 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbYEUApt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:45:49 -0400
Date: Wed, 21 May 2008 01:45:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, mchehab@infradead.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] or51132.c: unaligned
Message-ID: <20080521004548.GD28946@ZenIV.linux.org.uk>
References: <E1JycGV-0004yJ-SP@ZenIV.linux.org.uk> <1211330472.5915.228.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211330472.5915.228.camel@brick>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 05:41:12PM -0700, Harvey Harrison wrote:

> > +	return buf[0] | (buf[1] << 8);
> 
> return get_unaligned_le16(buf);

And the point of that would be?

> > +	firmwareAsize = le32_to_cpu(*((__le32*)fw->data));
> 
> ???firmwareAsize = le32_to_cpup((__le32 *)fw->data);

... and the point of that would be?  FWIW, I really don't like the ...p()
forms - they are hard to distinguish from normal ones visually and any
possible performance benefit is too small for most of the uses.  IOW,
it's mostly redundant API.
