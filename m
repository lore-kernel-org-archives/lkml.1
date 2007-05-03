Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbXECSnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbXECSnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 14:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbXECSnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 14:43:23 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52380 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309AbXECSnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 14:43:23 -0400
Date: Thu, 3 May 2007 19:43:21 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CIFS: make sec=none force an anonymous mount
Message-ID: <20070503184321.GA23056@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jeff Layton <jlayton@redhat.com>, linux-cifs-client@lists.samba.org,
	linux-kernel@vger.kernel.org
References: <20070503183231.GA1706@salusa.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503183231.GA1706@salusa.poochiereds.net>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 02:32:33PM -0400, Jeff Layton wrote:
> We had a customer report that attempting to make CIFS mount with a null
> username (i.e. doing an anonymous mount) doesn't work. Looking through the
> code, it looks like CIFS expects a NULL username from userspace in order
> to trigger an anonymous mount. The mount.cifs code doesn't seem to ever
> pass a null username to the kernel, however.
> 
> It looks also like the kernel can take a sec=none option, but it only seems
> to look at it if the username is already NULL. This seems redundant and
> effectively makes sec=none useless.
> 
> The following patch makes sec=none force an anonymous mount. I've briefly
> tested it and it seems to work. I suppose we could alternately do some
> stuff in userspace to make mount.cifs force a null username instead, but this
> seems more straightforward to me.

Looks useful.  In case you have some spare time at your hand it would
be really nice to convert cifs option parsing to the lib/parser.c code
and move all validation of the arguments into one place, so it's easily
understanable and better to maintain.

