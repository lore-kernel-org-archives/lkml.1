Return-Path: <linux-kernel-owner+w=401wt.eu-S1752822AbXCERlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbXCERlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 12:41:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbXCERlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 12:41:04 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:55949 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbXCERlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 12:41:03 -0500
Date: Mon, 5 Mar 2007 23:17:50 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Paul Jackson <pj@sgi.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>, dev@openvz.org,
       ebiederm@xmission.com, winget@google.com, containers@lists.osdl.org,
       menage@google.com, ckrm-tech@lists.sourceforge.net, xemul@sw.ru,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070305174750.GA14507@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070301133543.GK15509@in.ibm.com> <20070301113900.a7dace47.pj@sgi.com> <45E84682.6040500@openvz.org> <20070303174553.GB16051@MAIL.13thfloor.at> <20070303132244.80b5cb40.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070303132244.80b5cb40.pj@sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2007 at 01:22:44PM -0800, Paul Jackson wrote:
> I still can't claim to have my head around this, but what you write
> here, Herbert, writes here touches on what I suspect is a key
> difference between namespaces and resources that would make it
> impractical to accomplish both with a shared mechanism for aggregating
> tasks.

The way nsproxy is structured, its all pointers to actual namespace (or
in case of rcfs patch) resource objects.  This lets namespaces objects be in a 
flat hierarchy while resource objects are in tree-like hierarchy.
nsproxy itself doesnt decide any hierarchy. Its those objects pointed to
by nsproxy which can form different hierarchies. In fact the rcfs
patches allows such a combination afaics.

> > on every limit accounting or check? I think that
> > is quite a lot of overhead ...
> 
> Do either of these dereferences require locks?

A rcu_read_lock() should be required, which is not that expensive.

-- 
Regards,
vatsa
