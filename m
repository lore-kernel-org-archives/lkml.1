Return-Path: <linux-kernel-owner+w=401wt.eu-S934551AbXHGPT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934551AbXHGPT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 11:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750854AbXHGPTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 11:19:49 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58710 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755949AbXHGPTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 11:19:48 -0400
Date: Tue, 7 Aug 2007 10:19:45 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Andrew Morgan <morgan@kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morgan <agm@google.com>,
       casey@schaufler-ca.com, Andrew Morton <akpm@google.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, KaiGai Kohei <kaigai@kaigai.gr.jp>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] file capabilities: clear fcaps on inode change (v2)
Message-ID: <20070807151945.GA4864@sergelap.austin.ibm.com>
References: <20070806185231.GA21550@sergelap.austin.ibm.com> <Pine.LNX.4.64.0708070640160.31104@us.intercode.com.au> <20070807140827.GB8286@sergelap.austin.ibm.com> <Pine.LNX.4.64.0708070716380.28521@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708070716380.28521@us.intercode.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Morris (jmorris@namei.org):
> On Tue, 7 Aug 2007, Serge E. Hallyn wrote:
> 
> > Shall I resend without the LSM_NEED_LOCK, or do you still want a more
> > fundamental change?
> 
> 
> Removing the needlock is enough, the rest was just a query/suggestion.

Ok - I'll explictly lock the i_mutex in
fs/splice.c:generic_file_splice_write().  The ugliness there is that
the mutex will always be taken - even if there is no xattr to be
removed or even if CONFIG_SECURITY=n.

I guess I'll do some perf runs and see what kind of impact that has.

thanks,
-serge
