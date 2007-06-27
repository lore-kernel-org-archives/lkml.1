Return-Path: <linux-kernel-owner+w=401wt.eu-S1759290AbXF0Nhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290AbXF0Nhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 09:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbXF0Nhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 09:37:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:41162 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170AbXF0Nhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 09:37:43 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [AppArmor 00/44] AppArmor security module overview
Date: Wed, 27 Jun 2007 15:37:10 +0200
User-Agent: KMail/1.9.5
Cc: John Johansen <jjohansen@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070626230756.519733902@suse.de> <20070627022403.GB14656@suse.de> <0BE96E7A-204A-4CEC-BA8F-0112434F7B2C@mac.com>
In-Reply-To: <0BE96E7A-204A-4CEC-BA8F-0112434F7B2C@mac.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706271537.10566.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 June 2007 12:58, Kyle Moffett wrote:
> I seem to recall you could actually end up racing and building a path
> to the file in those directories as "a/d/0/3" or some other path at
> which it never even remotely existed. I'd love to be wrong,

Cheer up, you recall wrong.

> but I can't help but see this problem in any reverse-pathname-generation
> proposal which gets the locking right.

Have a look at how __d_path() is implemented (with the fixes): It takes the 
dcache_lock, and the vfsmount_lock where necessary, and this ensures that the 
pathname can't change under it, neither because of a rename nor unlink nor 
remount. The pathname computed is *exactly* the name the file has at that 
specific point time.

A few more details about how pathnames work are explained in the tech doc at:
http://forge.novell.com/modules/xfcontent/downloads.php/apparmor/LKML_Submission-May_07

Andreas
