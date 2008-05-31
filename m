Return-Path: <linux-kernel-owner+w=401wt.eu-S1753618AbYEaLqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618AbYEaLqh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 07:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbYEaLqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 07:46:25 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58884 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbYEaLqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 07:46:24 -0400
Date: Sat, 31 May 2008 14:46:21 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [bug] stuck localhost TCP connections, v2.6.26-rc3+
In-Reply-To: <20080531060947.GA26441@elte.hu>
Message-ID: <Pine.LNX.4.64.0805311431100.2329@wrl-59.cs.helsinki.fi>
References: <20080526115628.GA31316@elte.hu> <20080529084524.GA24892@elte.hu>
 <Pine.LNX.4.64.0805291332401.16829@wrl-59.cs.helsinki.fi> <20080529112257.GA18130@elte.hu>
 <20080530181839.GA31915@elte.hu> <20080531060947.GA26441@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 May 2008, Ingo Molnar wrote:

> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > ah, in retrospect i realized that this test had one flaw: some of the 
> > systems i the build cluster already ran a newer kernel and hence were 
> > targets for this bug.
> > 
> > so i turned off CONFIG_TCP_CONG_CUBIC on all the testboxes and 
> > rebooted the cluster boxes into 2.6.25, and the hung sockets are now 
> > gone. (about 150 successful iterations)
> > 
> > i did another change as well: i removed the localhost distcc 
> > component. I'll reinstate that now to make sure it's really related to 
> > TCP_CONG_CUBIC and not to localhost networking.
> 
> ok, once i added back the localhost distcc component and the hung kernel 
> build + stuck TCP socket bug happened again overnight:
> 
>  Active Internet connections (w/o servers)
>  Proto Recv-Q Send-Q Local Address               Foreign Address             State
>  tcp    72187      0 10.0.1.14:3632              10.0.1.14:47910             ESTABLISHED
>  tcp        0 174464 10.0.1.14:47910             10.0.1.14:3632              ESTABLISHED
> 
> so it seems distcc over localhost was the aspect that made it fail.
> 
> _Perhaps_ what matters is to have the new post-rc3 TCP code on _both_ 
> sides of the connection. But that is just a theory - it could be timing, 
> etc.

Btw, does your distcc perhaps happen enable TCP_DEFER_ACCEPT (there were
some post 2.6.25 changes into it)?

-- 
 i.
