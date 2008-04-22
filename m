Return-Path: <linux-kernel-owner+w=401wt.eu-S932719AbYDVC7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719AbYDVC7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 22:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758232AbYDVC67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 22:58:59 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59363 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758229AbYDVC66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 22:58:58 -0400
Message-Id: <1208833137.1366.1249155597@webmail.messagingengine.com>
X-Sasl-Enc: 4SNSoXDNymMQmLoPylu89wRFL6uG32RdHLD7HgurpI00 1208833137
From: "Kai" <epimetreus@fastmail.fm>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Ray Lee" <ray-lk@madrabbit.org>, linux-kernel@vger.kernel.org,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Mike Galbraith" <efault@gmx.de>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1206310206.17373.1243881033@webmail.messagingengine.com>
   <2c0942db0803231522w7c66f168xf7fea72d135ba395@mail.gmail.com>
   <1206341873.32060.1243929851@webmail.messagingengine.com>
   <20080327091711.GD30918@elte.hu>
   <1207250856.9779.1245934881@webmail.messagingengine.com>
   <20080421155339.GC31716@elte.hu>
Subject: Re: Serious performance regression in Wine applications and Linux      
   2.6.24.*
In-Reply-To: <20080421155339.GC31716@elte.hu>
Date: Mon, 21 Apr 2008 19:58:57 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That is possible; I will see if I'm only using one core in 2.6.23 as
well; if not, that might suggest what our problem is.

On Mon, 21 Apr 2008 17:53:42 +0200, "Ingo Molnar" <mingo@elte.hu> said:
> 
> * Kai <epimetreus@fastmail.fm> wrote:
> 
> > I did, however, test it on 2.6.25-rc8, and attached is the output of 
> > cfs-debug-info.sh
> 
> your vmstat:
> 
> -- vmstat: 
> --procs -----------memory---------- ---swap-- -----io---- -system--
> ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy
>  id wa
>  3  0      0 870540    340 746184    0    0   952   137  198 4752 21 12
>  60  7
>  1  0      0 870952    340 746320    0    0   128     0  356 17723 28 23
>  50  0
>  1  0      0 872224    340 746320    0    0     0    21  394 18066 30 20
>  50  0
>  1  0      0 872244    340 746320    0    0     0     0  353 17987 29 22
>  50  0
>  1  0      0 871416    340 746320    0    0     0     0  392 17971 28 22
>  50  0
> 
> suggests that there's a constant 50% idle time. Probably one core 
> running X and the client, the other core staying idle?
> 
> 	Ingo
