Return-Path: <linux-kernel-owner+w=401wt.eu-S1762941AbYGJSta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762941AbYGJSta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761096AbYGJSoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:44:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761079AbYGJSoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:44:12 -0400
Date: Thu, 10 Jul 2008 14:41:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Libcg Devel Mailing List <libcg-devel@lists.sourceforge.net>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <pzijlstr@redhat.com>,
       Kazunaga Ikeno <k-ikeno@ak.jp.nec.com>,
       Morton Andrew Morton <akpm@linux-foundation.org>,
       Thomas Graf <tgraf@redhat.com>
Subject: Re: [RFC] How to handle the rules engine for cgroups
Message-ID: <20080710184142.GC12043@redhat.com>
References: <20080701191126.GA17376@redhat.com> <20080703101957.b3856904.kamezawa.hiroyu@jp.fujitsu.com> <20080703155446.GB9275@redhat.com> <6599ad830807100223m2453963cwcfbe6eb1ad54d517@mail.gmail.com> <20080710104852.797fe79c@cuia.bos.redhat.com> <20080710154035.GA12043@redhat.com> <48763129.9060903@redhat.com> <20080710132546.264a89cd@cuia.bos.redhat.com> <48764950.3050405@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48764950.3050405@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 10:39:28AM -0700, Ulrich Drepper wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Rik van Riel wrote:
> > One easy way is to have a "migrate on exec" option added to the
> > process group code.
> 
> That's going to be ugly because the exec functions are signal-safe.
> I.e., they can happen at any time.  This would mean that one always has
> to set the migration policy before every exec call and that there must
> be a way to retrieve the currently selected policy so that it can
> potentially be restored.  This policy must be a thread property, not a
> process property.
> 

Sorry, I did not understand exactly what's the problem with signal
safe exec function. Before exec, we should be able to determine the
migration policy related to process/thread (either by reading file or
something else etc). Set the policy through cgroup file system. If exec
fails for some reason, we just need to go back to cgroup file system to
undo the effect of setting migration policy previously set for that thread.

Thanks
Vivek
