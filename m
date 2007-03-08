Return-Path: <linux-kernel-owner+w=401wt.eu-S1751998AbXCHAxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbXCHAxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 19:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbXCHAxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 19:53:31 -0500
Received: from mga05.intel.com ([192.55.52.89]:9206 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751998AbXCHAx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 19:53:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,262,1170662400"; 
   d="scan'208"; a="208423341:sNHT20280120"
Subject: Re: system call time increase when turning on CONFIG_PARAVIRT
From: Tim Chen <tim.c.chen@linux.intel.com>
Reply-To: tim.c.chen@linux.intel.com
To: Jeremy Fitzhardinge <jeremy@goop.org>, zach@vmware.com
Cc: linux-kernel@vger.kernel.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>
In-Reply-To: <45E8BE79.40200@goop.org>
References: <1172866274.4898.14.camel@localhost.localdomain>
	 <45E89CFB.4090905@goop.org> <1172877111.8383.4.camel@localhost.localdomain>
	  <45E8BE79.40200@goop.org>
Content-Type: text/plain
Organization: Intel
Date: Wed, 07 Mar 2007 16:02:04 -0800
Message-Id: <1173312124.8383.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-02 at 16:16 -0800, Jeremy Fitzhardinge wrote:

> 
> Yes, the intent is that running a CONFIG_PARAVIRT kernel on native
> hardware will have negligible performance hit compared to running a
> non-paravirt kernel.
> 
>     J

It turned out that VDSO was turned off by CONFIG_PARAVIRT option,
causing the system call to use inefficient int 0x80 which led to the
increase system_call time I was seeing.  I noted that Ingo has caught
this problem and proposed a patch to correct this issue in another mail
thread.

Tim
