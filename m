Return-Path: <linux-kernel-owner+w=401wt.eu-S1753689AbYL0Ig5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbYL0Ig5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 03:36:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbYL0Igs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 03:36:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295AbYL0Igr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 03:36:47 -0500
Date: Sat, 27 Dec 2008 00:34:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       David Howells <dhowells@redhat.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, mel@csn.ul.ie
Subject: Re: [PATCH] kgdb: more barrier in blank weak function
Message-Id: <20081227003448.b78b0a6f.akpm@linux-foundation.org>
In-Reply-To: <20081227081737.GA26218@elte.hu>
References: <494C0BF0.3080109@kernel.org>
	<20081223132127.GA5450@linux.vnet.ibm.com>
	<495153A4.5060201@kernel.org>
	<20081224163400.GA11562@linux.vnet.ibm.com>
	<49529CE1.4040005@kernel.org>
	<20081226091217.GA5100@linux.vnet.ibm.com>
	<4954AC7B.3020603@kernel.org>
	<20081226102716.GA31450@uranus.ravnborg.org>
	<4955B782.3030407@kernel.org>
	<4955B7EC.7050002@kernel.org>
	<20081227081737.GA26218@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Dec 2008 09:17:37 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
> > Impact: fix panic possible panic etc
> > 
> > some compiler seems to inline the weak global function if no line in it
> 
> >  kgdb_post_primary_code(struct pt_regs *regs, int e_vector, int err_code)
> >  {
> > -	return;
> > +	barrier();
> >  }
> 
> >  void __weak kgdb_disable_hw_debug(struct pt_regs *regs)
> >  {
> > +	barrier();
> >  }
> 
> seems like the barrier() is not enough - the only safe sequence seems to 
> be to turn it into a function that returns an integer.
> 

Give up, and ban that gcc version?  Adrian had a patch a while back,
but I don't know how he worked out the affected compiler versions.
