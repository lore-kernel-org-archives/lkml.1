Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbYJVDQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbYJVDQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 23:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbYJVDQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 23:16:09 -0400
Received: from NaN.false.org ([208.75.86.248]:57474 "EHLO nan.false.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbYJVDQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 23:16:08 -0400
X-Greylist: delayed 1250 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Oct 2008 23:16:08 EDT
Date: Tue, 21 Oct 2008 22:55:13 -0400
From: Daniel Jacobowitz <dan@debian.org>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-api@vger.kernel.org, tglx@linutronix.de, dave@linux.vnet.ibm.com,
       mingo@elte.hu, hpa@zytor.com, viro@zeniv.linux.org.uk
Subject: Re: [RFC v7][PATCH 2/9] General infrastructure for checkpoint
	restart
Message-ID: <20081022025513.GA7504@caradoc.them.org>
Mail-Followup-To: Oren Laadan <orenl@cs.columbia.edu>,
	"Serge E. Hallyn" <serue@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	torvalds@linux-foundation.org,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-api@vger.kernel.org, tglx@linutronix.de,
	dave@linux.vnet.ibm.com, mingo@elte.hu, hpa@zytor.com,
	viro@zeniv.linux.org.uk
References: <1224481237-4892-1-git-send-email-orenl@cs.columbia.edu> <1224481237-4892-3-git-send-email-orenl@cs.columbia.edu> <20081021124130.a002e838.akpm@linux-foundation.org> <20081021202410.GA10423@us.ibm.com> <48FE82DF.6030005@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FE82DF.6030005@cs.columbia.edu>
User-Agent: Mutt/1.5.17 (2008-05-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 09:33:19PM -0400, Oren Laadan wrote:
> >> What happens if I pass it a pid of a process which I _do_ own, but it
> >> does not refer to a container's init process?
> > 
> > I would assume that do_checkpoint() would return -EINVAL, but it's a
> > great question:  Oren, did you have another plan?
> 
> Since we intentional provide minimal functionality to keep the patchset
> simple and allow easy review - we only checkpoint one task; it doesn't
> really matter because we don't deal with the entire container.
> 
> With the ability to checkpoint multiple process we will have to ensure
> that we checkpoint an entire container. I planned to return -EINVAL if
> the target task isn't a container init(1). Another option, if people
> prefer, is to use any task in a container to "represent" the entire
> container.

I haven't been following - but why this whole container restriction?
Checkpoint/restart of individual processes is very useful too.
There are issues with e.g. IPC, but I'm not convinced they're
substantially different than the issues already present for a
container.

-- 
Daniel Jacobowitz
CodeSourcery
