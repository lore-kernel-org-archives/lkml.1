Return-Path: <linux-kernel-owner+w=401wt.eu-S933319AbYEGTOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933319AbYEGTOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760097AbYEGTOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:14:30 -0400
Received: from ns1.suse.de ([195.135.220.2]:42530 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763671AbYEGTO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:14:28 -0400
Date: Wed, 7 May 2008 12:08:38 -0700
From: Greg KH <gregkh@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Al Viro <viro@ftp.linux.org.uk>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 10/11] avoid kobject name conflict with different
	namespaces
Message-ID: <20080507190838.GA4467@suse.de>
References: <20080506173030.653828076@theryb.frec.bull.fr> <20080506173335.922289888@theryb.frec.bull.fr> <m13aoueyq8.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m13aoueyq8.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 11:49:19AM -0700, Eric W. Biederman wrote:
> Unless there is another path I think placing an additional pointer in
> kobj_type so we can find it through ktype is the simplest solution.
> Although using the kset is also sane.

Ick, ick, ick :)

> The easiest and most trivially correct thing to do would be to simply
> remove the unnecessary check from kobject_rename.  We perform the
> check at the upper levels in the network anyway.  And kobject_rename
> is only used by the network stack.

Wireless uses it also for some things, and it requires that it fail if a
duplicate is found.  I thought that s390 also used it, but I don't see
that usage in the tree anymore, perhaps they switched to something else.

good luck,

greg k-h
