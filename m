Return-Path: <linux-kernel-owner+w=401wt.eu-S1759119AbZBLP4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759119AbZBLP4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 10:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbZBLP4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 10:56:25 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:60373 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbZBLP4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 10:56:25 -0500
Date: Thu, 12 Feb 2009 08:39:32 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [CRED bug?] 2.6.29-rc3 don't survive on stress workload
Message-ID: <20090212143932.GA10101@us.ibm.com>
References: <20090212202118.0A58.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090210142443.629E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <27421.1234436992@redhat.com> <27547.1234440246@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27547.1234440246@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > but perhaps I am merely lucky guy.
> 
> Or perhaps Serge's patch fixes it - as I said I don't have it applied - though
> I don't see exactly why it should fix this problem...

I believe it was because

	1. put_user_ns() was being called before the uid (which
	   was in the init_user_ns) was unhashed

	2. alloc_uid would race in before the unhash, find
	   the hashed uid, and reuse it - without doing
	   another get_user_ns().

so a reference was lost.

-serge
