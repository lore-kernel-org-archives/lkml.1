Return-Path: <linux-kernel-owner+w=401wt.eu-S1757975AbXEJPan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbXEJPan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 11:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbXEJPah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 11:30:37 -0400
Received: from mr.exanet.com ([212.143.73.109]:53701 "EHLO mr.exanet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017AbXEJPag convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 11:30:36 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] NLM program ID for user space NLM server
Date: Thu, 10 May 2007 18:30:35 +0300
Message-ID: <A6FDE6B975803043804A49F12F49028E0F59D3@hawk.exanet-il.co.il>
In-Reply-To: <1178804340.6481.3.camel@heimdal.trondhjem.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] NLM program ID for user space NLM server
Thread-Index: AceTCJP3x5ZjeNujT2qsCRbHdrRKswAD4F+Q
From: "Menny Hamburger" <menny@exanet.com>
To: "Trond Myklebust" <trond.myklebust@fys.uio.no>
Cc: "Neil Brown" <neilb@suse.de>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The idea in the change was to be able to override NLM_PROGRAM with
another definition (from our slightly customized build system), so that
the kernel never tries to register port 100021.

We understand that if all mounts are with 'nolock' this wouldn't happen,
and indeed, we configured our mounts that way, but we want to protect
ourself from some innocent mounter that doesn't know/care about NLM,
doesn't use 'nolock' and could cause the kernel to take away our port.
This of course happened in real life.

If such patch would be accepted, it could save some time to anyone who
tries to run user mode NLM server, but it's pretty esoteric, so maybe
this discussion is enough to document the issue. 

-----Original Message-----
From: Trond Myklebust [mailto:trond.myklebust@fys.uio.no] 
Sent: Thursday, May 10, 2007 3:39 PM
To: Menny Hamburger
Cc: Neil Brown; linux-kernel@vger.kernel.org
Subject: RE: [PATCH] NLM program ID for user space NLM server

On Thu, 2007-05-10 at 13:59 +0300, Menny Hamburger wrote:
> Hi,
> 
> We have a our own userland NFSD and NLM service running that implement

> all the NLM/NFS functionality.
> We do not want to modify the way the client does his mounts.
> 
> M.

The client needs to have lockd running (as service 100021) in order to
allow the NSM daemon to notify it of server reboots.

Trond

