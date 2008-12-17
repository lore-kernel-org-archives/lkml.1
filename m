Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752657AbYLQU7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbYLQU7U (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 15:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbYLQU7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 15:59:05 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:33219 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbYLQU7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 15:59:04 -0500
Date: Wed, 17 Dec 2008 20:59:02 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/15] fixing audit rule ordering mess, part 1
Message-ID: <20081217205902.GH28946@ZenIV.linux.org.uk>
References: <E1LCoiI-0000Eu-Ty@ZenIV.linux.org.uk> <1229538488.3384.33.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229538488.3384.33.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 01:28:08PM -0500, Eric Paris wrote:

> I don't see why prio is only important on AUDIT_FILTER_EXIT.  Couldn't I
> end up with stupidity with entry,never  ?


AUDIT_WATCH and AUDIT_INODE can live only on exit chain.  I.e. we don't have
that problem - other chains sit on the lists of their own and there the
list ordering itself takes care of everything.  Exit chain has parts in
sitting in hash instead of the primary list.
