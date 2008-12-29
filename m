Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbYL2VrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbYL2VrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 16:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbYL2VrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 16:47:05 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:35816 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbYL2VrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 16:47:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RA7tyByS6sYojBi0HCTpWvDVwkQClDbMYZLyUwbF5mtU3wsdT5aw9Jgiwlr8MczF0P
         ijM2DfTntHrPIjblkup2cwK80WKZ5KPpdTWp12k3o5tYeBumVIFgd8NomGr0Qr+dgz+k
         5CV0tI25wL/GBiicHdIHsN1wvltSIIdzascA0=
Date: Mon, 29 Dec 2008 22:46:58 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH] tracing/kmemtrace: normalize the raw tracer event to
	the unified tracing API
Message-ID: <20081229214657.GA5829@nowhere>
References: <4959443f.09a1660a.44f3.2686@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4959443f.09a1660a.44f3.2686@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And of course the headers of the trace have been zapped by git-commit :-)
An example with the headers:

# tracer: kmemtrace
#
#
# ALLOC  TYPE  REQ   GIVEN  FLAGS           POINTER         NODE    CALLER
# FREE   |      |     |       |              |   |            |        |
# |

  -      C                            0xffff88007c088780          file_free_rcu
  +      K   4096   4096   000000d0   0xffff88007cad6000     -1   getname
  -      C                            0xffff88007cad6000          putname
  +      K   4096   4096   000000d0   0xffff88007cad6000     -1   getname
  +      K    240    240   000000d0   0xffff8800790dc780     -1   d_alloc
  -      C                            0xffff88007cad6000          putname
  +      K   4096   4096   000000d0   0xffff88007cad6000     -1   getname
  +      K    240    240   000000d0   0xffff8800790dc870     -1   d_alloc
  -      C                            0xffff88007cad6000          putname
  +      K   4096   4096   000000d0   0xffff88007cad6000     -1   getname
  +      K    240    240   000000d0   0xffff8800790dc960     -1   d_alloc
  +      K   1304   1312   000000d0   0xffff8800791d7340     -1   reiserfs_alloc_inode



