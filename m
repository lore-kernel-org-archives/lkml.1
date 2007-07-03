Return-Path: <linux-kernel-owner+w=401wt.eu-S1760992AbXGCUCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760992AbXGCUCH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 16:02:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757002AbXGCUBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 16:01:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:39020 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756889AbXGCUBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 16:01:54 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [AppArmor 32/44] Enable LSM hooks to distinguish operations on file descriptors from operations on pathnames
Date: Tue, 3 Jul 2007 22:01:47 +0200
User-Agent: KMail/1.9.5
Cc: James Morris <jmorris@namei.org>, John Johansen <jjohansen@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Miklos Szeredi <mszeredi@suse.cz>
References: <20070626230756.519733902@suse.de> <200706282015.51430.agruen@suse.de> <1183470580.12218.253.camel@moss-spartans.epoch.ncsc.mil>
In-Reply-To: <1183470580.12218.253.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2573
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200707032201.47586.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 July 2007 15:49, Stephen Smalley wrote:
> So you don't actually need/use the struct file pointer; you just need a
> flag indicating whether or not access was by open file descriptor or by
> pathname?

Yes, indeed. Given that struct iattr already defines ATTR_FILE and ia_file, I 
didn't see a good reason to invent something new when we can just use the 
existing mechanism.

> And what does this mean for a process that has "changed hats"?  Which
> might not be authorized to access the file anymore, even via an already
> opened descriptor.

If that file is still part of the namespace (i.e., not deleted), then access 
to the file descriptor is revalidated against the new profile ("changing hat" 
is switching to a different profile). If the file has already been deleted, 
then access is granted. There isn't that much of a difference between a 
deleted file and say, and anonymous pipe: both can be used by processes to 
communicate, and both will cease their lives once no longer referenced.

Later with IPC mediation, we'll obviously have to control which profiles may 
communicate with which other profiles. One possibility for that would be to 
map profiles and allowed communication channels to labels and access rules.

Andreas
