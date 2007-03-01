Return-Path: <linux-kernel-owner+w=401wt.eu-S965349AbXCAQrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965349AbXCAQrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 11:47:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965372AbXCAQrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 11:47:09 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37756 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965349AbXCAQrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 11:47:07 -0500
Date: Thu, 1 Mar 2007 22:16:37 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: menage@google.com, ebiederm@xmission.com, sam@vilain.net,
       akpm@linux-foundation.org, pj@sgi.com, dev@sw.ru, xemul@sw.ru,
       containers@lists.osdl.org, winget@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH 1/2] rcfs core patch
Message-ID: <20070301164637.GB28323@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070301133543.GK15509@in.ibm.com> <20070301134528.GL15509@in.ibm.com> <20070301163126.GB17027@sergelap.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301163126.GB17027@sergelap.austin.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 10:31:26AM -0600, Serge E. Hallyn wrote:
> we've already had some trouble with nsproxy holding things with
> different lifetimes.  As it happens the solution this time was to put
> the pid namespace where it belongs - not in nsproxy - so maybe moving
> this info into nsproxies will be fine, it just rings a warning bell.

nsproxy seems the best place to me to hang off the resource control
objects (nsproxy->ctlr_data[]). These objects provide information like
resource limit etc required by the resource controllers.

Alternately we could move them to task_struct which would cause unnecessary 
duplication of pointers (and wastage of space).

-- 
Regards,
vatsa
