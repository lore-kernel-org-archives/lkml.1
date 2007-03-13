Return-Path: <linux-kernel-owner+w=401wt.eu-S1753287AbXCMPwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbXCMPwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 11:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbXCMPwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 11:52:55 -0400
Received: from MAIL.13thfloor.at ([213.145.232.33]:44218 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbXCMPwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 11:52:54 -0400
Date: Tue, 13 Mar 2007 16:52:51 +0100
From: Herbert Poetzl <herbert@13thfloor.at>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Kirill Korotaev <dev@sw.ru>, menage@google.com, pj@sgi.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, winget@google.com,
       containers@lists.osdl.org, akpm@linux-foundation.org,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       xemul@sw.ru
Subject: Re: [ckrm-tech] [PATCH 1/2] rcfs core patch
Message-ID: <20070313155251.GN8755@MAIL.13thfloor.at>
Mail-Followup-To: Srivatsa Vaddagiri <vatsa@in.ibm.com>,
	Kirill Korotaev <dev@sw.ru>, menage@google.com, pj@sgi.com,
	"Eric W. Biederman" <ebiederm@xmission.com>, winget@google.com,
	containers@lists.osdl.org, akpm@linux-foundation.org,
	ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	xemul@sw.ru
References: <m1slcg8m4f.fsf@ebiederm.dsl.xmission.com> <20070308101347.GA29051@in.ibm.com> <20070309004816.GB4506@MAIL.13thfloor.at> <45F127AB.5070704@sw.ru> <20070309132136.GA14907@MAIL.13thfloor.at> <45F437C9.2090108@sw.ru> <20070312230053.GD21258@MAIL.13thfloor.at> <45F66096.20900@sw.ru> <20070313135505.GD8755@MAIL.13thfloor.at> <20070313141137.GD19939@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070313141137.GD19939@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 07:41:37PM +0530, Srivatsa Vaddagiri wrote:
> On Tue, Mar 13, 2007 at 02:55:05PM +0100, Herbert Poetzl wrote:
> > yes, tons of locking, complicated indirections and
> > a lot of (partially hard to understand) code ...
> 
> Are you referring to these issues in the general Paul Menage's 
> container code or in the RSS-control code posted by Pavel?

the container code has quite a number of locks, including
the container(_manage)_lock/unlock, but those should not
hurt that much, as restructuring is not on the hot path
(as far as I can tell)

but I was more referring to the charge/uncharge(_locked)
inlines which will be execised quite often ...

and btw, why not use a 'generic' accounting macro/inline
to do the accounting for all the different resources like
files, rss, sockets (instead of duplicating the code
over and over again)

that would really simplify improving the accounting by
switching to atomics or even per cpu based mechanisms

best,
Herbert

> -- 
> Regards,
> vatsa
> _______________________________________________
> Containers mailing list
> Containers@lists.osdl.org
> https://lists.osdl.org/mailman/listinfo/containers
