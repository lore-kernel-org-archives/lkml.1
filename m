Return-Path: <linux-kernel-owner+w=401wt.eu-S1761729AbXEJRLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761729AbXEJRLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 13:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761017AbXEJRLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 13:11:22 -0400
Received: from mr.exanet.com ([212.143.73.109]:39003 "EHLO mr.exanet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760953AbXEJRLV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 13:11:21 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] NLM program ID for user space NLM server
Date: Thu, 10 May 2007 20:11:19 +0300
Message-ID: <A6FDE6B975803043804A49F12F49028E0F59DA@hawk.exanet-il.co.il>
In-Reply-To: <1178816661.6775.12.camel@heimdal.trondhjem.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] NLM program ID for user space NLM server
Thread-Index: AceTJUM2HweLjK/ITee5kT5DBlDE+gAAICCQ
From: "Menny Hamburger" <menny@exanet.com>
To: "Trond Myklebust" <trond.myklebust@fys.uio.no>
Cc: "Neil Brown" <neilb@suse.de>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Well,

That maybe a better idea then what we do - we'll try it.

Thnx,
Menny

-----Original Message-----
From: Trond Myklebust [mailto:trond.myklebust@fys.uio.no] 
Sent: Thursday, May 10, 2007 7:04 PM
To: Menny Hamburger
Cc: Neil Brown; linux-kernel@vger.kernel.org
Subject: RE: [PATCH] NLM program ID for user space NLM server

On Thu, 2007-05-10 at 19:45 +0300, Menny Hamburger wrote:
> Yes, but in our case we don't care. This is a dedicated server where 
> we don't see any usage for NLM client. We just want to prevent the 
> kernel from taking the port in case of some accidental NFS mount that 
> ommitted 'nolock'.

Which is _wrong_. If you omit the 'nolock' mount option, then the client
_does_ use NLM locking, and so will need the RPC downcall.

If you don't need NLM locking, and want to make sure nobody else can
enable it, then you can triviall 'fix' this on your server by patching
it to force the nolock mount option. This isn't a patch that we
particularly want to see in mainline, though.

Trond

