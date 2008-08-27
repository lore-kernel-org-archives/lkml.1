Return-Path: <linux-kernel-owner+w=401wt.eu-S1752228AbYH0RDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbYH0RDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 13:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750802AbYH0RDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 13:03:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbYH0RDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 13:03:30 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080827173236.2198786e@lxorguk.ukuu.org.uk>
References: <20080827173236.2198786e@lxorguk.ukuu.org.uk> <20080827160439.GA12085@us.ibm.com> <200808262057.51606.agruen@suse.de> <20080827135206.GA12919@us.ibm.com> <200808271729.18220.agruen@suse.de> <26995.1219853604@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dhowells@redhat.com, "Serge E. Hallyn" <serue@us.ibm.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       "Andrew G. Morgan" <morgan@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] file capabilities: Add no_file_caps switch
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Wed, 27 Aug 2008 18:00:07 +0100
Message-ID: <27726.1219856407@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> That gets foul in another way - bounding the worst case RCU
> memory utilisation if someone is sitting doing things like while(1)
> change_credentials();

Is it worth calling synchronize_rcu() in commit_creds() to make sure that the
old memory will have been freed if possible?  Admittedly that'll slow setuid()
and co. down, but it should avoid that problem.

David
