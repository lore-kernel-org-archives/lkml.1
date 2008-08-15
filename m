Return-Path: <linux-kernel-owner+w=401wt.eu-S1750928AbYHOFvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750928AbYHOFvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 01:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbYHOFvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 01:51:05 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:57701 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbYHOFvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 01:51:04 -0400
Subject: Re: request->ioprio
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       =?UTF-8?Q?=E5=90=89=E5=B7=9D_=E6=8B=93=E5=93=89?= 
	<yoshikawa.takuya@oss.ntt.co.jp>,
       dpshah@google.com
In-Reply-To: <200808141216.33688.rusty@rustcorp.com.au>
References: <1218014196.4419.44.camel@sebastian.kern.oss.ntt.co.jp>
	 <200808070633.06112.rusty@rustcorp.com.au>
	 <1218611163.8001.108.camel@sebastian.kern.oss.ntt.co.jp>
	 <200808141216.33688.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Organization: NTT Open Source Software Center
Date: Fri, 15 Aug 2008 14:51:02 +0900
Message-Id: <1218779462.5291.59.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-14 at 12:16 +1000, Rusty Russell wrote:
> On Wednesday 13 August 2008 17:06:03 Fernando Luis Vázquez Cao wrote:
> > Besides, I guess that accessing the io context information (such as
> > ioprio) of a request through elevator-specific private structures is not
> > something we want virtio_blk (or future users) to do.
> 
> The only semantic I assumed was "higher is better".  The server (ie. host) can 
> really only use the information to schedule between I/Os for that particular 
> guest anyway.
Does that mean you are not going to incorporate the prio class system
that is used in Linux?

Please note that the three upper bits of ioprio contain the ioprio
class. We currently have three classes encoded as follows:

  IOPRIO_CLASS_RT: 1
  IOPRIO_CLASS_BE: 2
  IOPRIO_CLASS_IDLE: 3

As things stand now, if we passed ioprio as is to the backend driver
requests would get priority inverted. For example, requests in the idle
class would be prioritized in detriment of the real time ones.

This problem could be solved in req_get_ioprio() (already in Jen's
tree), or, alternatively, we could change the enum where the ioprio
classes are defined.

What are your plans regarding prio classes?

