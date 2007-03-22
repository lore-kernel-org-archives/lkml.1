Return-Path: <linux-kernel-owner+w=401wt.eu-S933898AbXCVJtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933898AbXCVJtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 05:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932773AbXCVJtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 05:49:46 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:53708 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933898AbXCVJti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 05:49:38 -0400
Date: Thu, 22 Mar 2007 15:26:51 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: menage@google.com
Cc: akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, winget@google.com,
       rohitseth@google.com, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 1/7] containers (V7): Generic container system abstracted from cpusets code
Message-ID: <20070322095651.GA17796@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070212081521.808338000@menage.corp.google.com> <20070212085104.130746000@menage.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070212085104.130746000@menage.corp.google.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 12:15:22AM -0800, menage@google.com wrote:
> +static void remove_dir(struct dentry *d)
> +{
> +	struct dentry *parent = dget(d->d_parent);

Don't we need to lock parent inode's mutex here? sysfs seems to take
that lock.

> +
> +	d_delete(d);
> +	simple_rmdir(parent->d_inode, d);
> +	dput(parent);
> +}

-- 
Regards,
vatsa
