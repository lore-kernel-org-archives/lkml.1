Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbYFDCyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbYFDCyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 22:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbYFDCyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 22:54:19 -0400
Received: from linode.ducksong.com ([64.22.125.164]:57545 "EHLO
	linode.ducksong.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbYFDCyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 22:54:18 -0400
Subject: Re: [fixed] [patch] Re: [bug] stuck localhost TCP connections,
	v2.6.26-rc3+
From: Patrick McManus <mcmanus@ducksong.com>
To: Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: David Miller <davem@davemloft.net>, mingo@elte.hu, peterz@infradead.org,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       rjw@sisk.pl, Andrew Morton <akpm@linux-foundation.org>,
       johnpol@2ka.mipt.ru
In-Reply-To: <Pine.LNX.4.64.0806040208350.7315@wrl-59.cs.helsinki.fi>
References: <20080603094057.GA29480@elte.hu>
	 <Pine.LNX.4.64.0806032245490.3474@wrl-59.cs.helsinki.fi>
	 <Pine.LNX.4.64.0806040052270.3474@wrl-59.cs.helsinki.fi>
	 <20080603.150344.145518113.davem@davemloft.net>
	 <Pine.LNX.4.64.0806040208350.7315@wrl-59.cs.helsinki.fi>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 03 Jun 2008 22:54:52 -0400
Message-Id: <1212548093.12617.0.camel@tng>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-04 at 02:22 +0300, Ilpo Järvinen wrote:
==
> --
> [PATCH] tcp DEFER_ACCEPT: fix racy access to listen_sk
> 
> It seems that replacement of DA code also moved parts outside
> of appropriate locking. The Ingo's problem seems to come from
> the fact that two flows could now race in
> (inet_csk_)reqsk_queue_add corrupting the queue. ...This can
> leave dangling socks around which won't resolve themselves
> without stimuli from outside (e.g., external RST would help
> I think).


﻿Ilpo, has anyone told you today that you rock? Well allow me - you
rock.
> 
do_rcv() clearly has the listening socket locked in the non-DA case, and
in the DA case it is the 'child' ESTABLISHED socket that is locked -
leaving the accept queue unprotected. So simple.

-Pat


