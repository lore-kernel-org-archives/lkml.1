Return-Path: <linux-kernel-owner+w=401wt.eu-S1760224AbYBGOFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224AbYBGOFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 09:05:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758513AbYBGOF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 09:05:28 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53547 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758211AbYBGOFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 09:05:25 -0500
Date: Thu, 7 Feb 2008 08:05:21 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: serue@us.ibm.com, akpm@linux-foundation.org, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 07/10] unprivileged mounts: add sysctl tunable for
	"safe" property
Message-ID: <20080207140521.GC4058@sergelap.austin.ibm.com>
References: <20080205213616.343721693@szeredi.hu> <20080205213705.120219893@szeredi.hu> <20080206202110.GA20528@sergelap.ibm.com> <E1JMrXw-0000qq-O9@pomaz-ex.szeredi.hu> <20080206224527.GB24246@sergelap.austin.ibm.com> <E1JN1p3-0001zF-4l@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JN1p3-0001zF-4l@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Miklos Szeredi (miklos@szeredi.hu):
> > > Maybe sysctls just need to check capabilities, instead of uids.  I
> > > think that would make a lot of sense anyway.
> > 
> > Would it be as simple as tagging the inodes with capability sets?  One
> > set for writing, or one each for reading and writing?
> 
> Yes, or something even simpler, like mapping the owner permission bits
> to CAP_SYS_ADMIN.  There seem to be very few different permissions
> under /proc/sys:
> 
> --w-------
> -r--r--r--
> -rw-------
> -rw-r--r--
> 
> As long as the group and other bits are always the same, and we accept
> that the owner bits really mean CAP_SYS_ADMIN and not something else,

But I would assume some things under /proc/sys/net/ipv4 or
/proc/sys/net/ath0 require CAP_NET_ADMIN rather than CAP_SYS_ADMIN?

> then the permission check would not need to look at uids or gids at
> all.
> 
> Miklos
> -
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
