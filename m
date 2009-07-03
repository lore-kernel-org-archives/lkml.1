Return-Path: <linux-kernel-owner+w=401wt.eu-S1757049AbZGCQII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049AbZGCQII (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 12:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbZGCQH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 12:07:57 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:26851 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020AbZGCQH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 12:07:56 -0400
Date: Fri, 3 Jul 2009 09:07:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Nico Schottelius <nico-linux-20090703@schottelius.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: How to reliable rebuild different kernel versions with the same
 config?
Message-Id: <20090703090729.8c95a1e7.randy.dunlap@oracle.com>
In-Reply-To: <20090703144640.GA24922@ikn.schottelius.org>
References: <20090703144640.GA24922@ikn.schottelius.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt004.oracle.com [141.146.116.13]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010208.4A4E2CC3.0187:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jul 2009 16:46:42 +0200 Nico Schottelius wrote:

> Hello!
> 
> We encounter very strange delays here in a test application
> on different kernels. To debug it a bit better, we would like to
> 
> - start the application, store results
> - build the next older kernel
> - install it
> - boot it
> - goto 1 (*)
> 
> The problem is, that after changing the version, make all or make oldconfig
> prompt us to fillout some values, which is problematic, because we
> want to run it automatically.

Use:
$ yes "" | make oldconfig
to supply replies to the prompts.

> Is there a way to use a base config, that includes support for the
> hardware (ibm x3550 m2) and all the other values are adopted from
> default values?

See Documentation/kbuild/kconfig.txt, the section on KCONFIG_ALLCONFIG.
I use this quite a bit.

> make defconfig && cat myconfig >> .config does not do the trick :-)

That needs a "make oldconfig" afterwards, then it might work.

> Sincerly,
> 
> Nico
> 
> (*): This is so far already automated, have a look at
>   http://git.schottelius.org/?p=nsbin;a=commit;h=31461434cbda96bfb71c741c9510b1d92dcbb161
> 
> -- 
> Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
