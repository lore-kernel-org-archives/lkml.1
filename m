Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbZKLVle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbZKLVle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 16:41:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbZKLVl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 16:41:29 -0500
Received: from tundra.namei.org ([65.99.196.166]:56688 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289AbZKLVl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 16:41:28 -0500
Date: Fri, 13 Nov 2009 08:41:26 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Casey Schaufler <casey@schaufler-ca.com>
cc: Julia Lawall <julia@diku.dk>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/4] security/selinux: decrement sizeof size in strncmp
In-Reply-To: <4AFC3620.2020809@schaufler-ca.com>
Message-ID: <alpine.LRH.2.00.0911130833220.5497@tundra.namei.org>
References: <Pine.LNX.4.64.0911120849050.16627@ask.diku.dk> <alpine.LRH.2.00.0911121857110.31071@tundra.namei.org> <20091112145314.GA24682@us.ibm.com> <Pine.LNX.4.64.0911121556390.19779@ask.diku.dk> <4AFC3620.2020809@schaufler-ca.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009, Casey Schaufler wrote:

> I strongly suggest that this is not what is wanted.
>     strcmp(x,y)
> and
>     strncmp(x,y,sizeof(y))
> 
> are functionally equivalent and strcmp has a bad reputation in
> the security community because it is associated with potential
> buffer overrun issues.

Do you see potential for a buffer overrun in this case?

The strings being compared are "sysfs" and the name field of 'struct 
file_system_type'.  The kernel code elsewhere assumes the latter string to 
be a valid zero-terminated string, and we should, too.


- James
-- 
James Morris
<jmorris@namei.org>
