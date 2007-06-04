Return-Path: <linux-kernel-owner+w=401wt.eu-S1761626AbXFDTOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761626AbXFDTOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 15:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761729AbXFDTOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 15:14:19 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:32933 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761337AbXFDTOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 15:14:17 -0400
Date: Mon, 4 Jun 2007 14:14:12 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: menage@google.com
Cc: akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       vatsa@in.ibm.com, ebiederm@xmission.com, haveblue@us.ibm.com,
       svaidy@linux.vnet.ibm.com, balbir@in.ibm.com, pj@sgi.com, cpw@sgi.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
Subject: Re: [PATCH 00/10] Containers(V10): Generic Process Containers
Message-ID: <20070604191412.GA901@sergelap.austin.ibm.com>
References: <20070529130104.461765000@menage.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529130104.461765000@menage.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

I've got two problems working with this patchset:

1. A task can't join a cpuset unless 'cpus' and 'mems' are set.  These
don't seem to automatically inherit the parent's values.  So when I do

	mount -t container -o ns,cpuset nsproxy /containers
	(unshare a namespace)

the unshare fails because container_clone() created a new cpuset
container but the task couldn't automatically enter that new cpuset.

2. I can't delete containers because of the files they contain, and
am not allowed to delete those files by hand.

thanks,
-serge
