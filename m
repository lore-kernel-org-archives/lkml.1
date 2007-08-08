Return-Path: <linux-kernel-owner+w=401wt.eu-S934384AbXHHTcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934384AbXHHTcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 15:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761043AbXHHTcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 15:32:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39480 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759661AbXHHTcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 15:32:10 -0400
Date: Wed, 8 Aug 2007 20:32:09 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: linux-kernel@vger.kernel.org, John Johansen <jjohansen@suse.de>,
       Jan Blunck <jblunck@suse.de>, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: Re: [RFC 01/10] Split up struct nameidata
Message-ID: <20070808193209.GA31354@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andreas Gruenbacher <agruen@suse.de>, linux-kernel@vger.kernel.org,
	John Johansen <jjohansen@suse.de>, Jan Blunck <jblunck@suse.de>,
	Erez Zadok <ezk@cs.sunysb.edu>,
	Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
References: <20070808171622.632749741@suse.de> <20070808171643.542685765@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070808171643.542685765@suse.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 07:16:23PM +0200, Andreas Gruenbacher wrote:
> Split up struct nameidata into struct vfs_lookup with the lookup result
> and intent and the remaining fields for performing an actual lookup.

Looks good as a start, but please don't put a struct path in there,
as the vfsmount will go away from the lookup intent as soon as we have
a new inode operation for atomic create + open, and not having it in the
struct path will make that removal a lot less painfull.

