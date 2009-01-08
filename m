Return-Path: <linux-kernel-owner+w=401wt.eu-S1762766AbZAHUfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762766AbZAHUfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 15:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761742AbZAHUfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 15:35:36 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60511 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761598AbZAHUff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 15:35:35 -0500
Message-ID: <496663B6.3090709@redhat.com>
Date: Thu, 08 Jan 2009 15:36:06 -0500
From: Casey Dahlin <cdahlin@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Oleg Nesterov <oleg@redhat.com>, Ulrich Drepper <drepper@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND][RFC PATCH v2] waitfd
References: <49639EB8.40204@redhat.com>	<4963ABF0.6070400@redhat.com>	<20090107123457.GB16268@elte.hu>	<20090107205322.5F8C7FC3E0@magilla.sf.frob.com>	<a36005b50901071302q70160bady41abc5ed2b105474@mail.gmail.com>	<20090108143220.GA8717@redhat.com> <20090108193530.99D74FC3DD@magilla.sf.frob.com>
In-Reply-To: <20090108193530.99D74FC3DD@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
>>> Since waitfd shouldn't consume the child termination notification
>>> waitfd should be more widely usable than the wait*() interfaces.
> 
> waitid can be used that way with WNOWAIT.

Yes, but waitfd does not have this flag. The reason being waitfd just calls waitid internally, and there is no guarantee (afaik) that calling waitid with WNOWAIT multiple times in succession will yield different results each time. This breaks the streaming behavior of the descriptor.

--CJD
