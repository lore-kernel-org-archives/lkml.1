Return-Path: <linux-kernel-owner+w=401wt.eu-S933856AbXEQFAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933856AbXEQFAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 01:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760030AbXEQFAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 01:00:31 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:36890 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759997AbXEQFAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 01:00:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZcHfGuNDoawgWjVctTScF4MHaAUsGV3Q6iz/FaN3JQwplJxCiBpaFqYKV0Sgtfn3dgc5LpuhUkkXYxVHIYA4NiKHppr0ZrYpdsewRgT/TV4H5XvRfY/99LS+JLehKqgNki4PzNKbsafKZJXos0BzRLja6WPnTg9j1DwVpjAgPGo=
Message-ID: <a781481a0705162200o744e16di5a1b8b6e41826d9d@mail.gmail.com>
Date: Thu, 17 May 2007 10:30:29 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: bharata@linux.vnet.ibm.com
Subject: Re: Convert namespace_sem to a mutex
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070517045041.GA4462@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070517045041.GA4462@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/17/07, Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:
> From: Bharata B Rao <bharata@linux.vnet.ibm.com>
>
> namespace_sem is a rwsem. It is acquired as read sem at only one place(used
                                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Actually, this ...

> by /proc/mounts, /proc/<pid>/mounts and /proc/<pid>/mountstats). In all other
> cases it is acquired as a write sem. So, as there is not more than one reader
                                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

... does not mean this. Multiple threads could be reading mounts or
mountstats, and otoh mount(2) and umount(2) (acquire it as write sem)
could be less frequent?

> for this sem, this can be a generic sem (and not rwsem) and if so it can be
> a mutex.
