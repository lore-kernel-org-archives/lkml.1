Return-Path: <linux-kernel-owner+w=401wt.eu-S1754382AbZKLV7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbZKLV7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 16:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435AbZKLV7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 16:59:48 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:42324 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324AbZKLV7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 16:59:47 -0500
Date: Thu, 12 Nov 2009 22:59:49 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: James Morris <jmorris@namei.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/4] security/selinux: decrement sizeof size in strncmp
In-Reply-To: <alpine.LRH.2.00.0911130833220.5497@tundra.namei.org>
Message-ID: <Pine.LNX.4.64.0911122257090.432@ask.diku.dk>
References: <Pine.LNX.4.64.0911120849050.16627@ask.diku.dk>
 <alpine.LRH.2.00.0911121857110.31071@tundra.namei.org> <20091112145314.GA24682@us.ibm.com>
 <Pine.LNX.4.64.0911121556390.19779@ask.diku.dk> <4AFC3620.2020809@schaufler-ca.com>
 <alpine.LRH.2.00.0911130833220.5497@tundra.namei.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Nov 2009, James Morris wrote:

> On Thu, 12 Nov 2009, Casey Schaufler wrote:
> 
> > I strongly suggest that this is not what is wanted.
> >     strcmp(x,y)
> > and
> >     strncmp(x,y,sizeof(y))
> > 
> > are functionally equivalent and strcmp has a bad reputation in
> > the security community because it is associated with potential
> > buffer overrun issues.
> 
> Do you see potential for a buffer overrun in this case?
> 
> The strings being compared are "sysfs" and the name field of 'struct 
> file_system_type'.  The kernel code elsewhere assumes the latter string to 
> be a valid zero-terminated string, and we should, too.

The sizeof only helps for the zero-termination of y, ie "sysfs".  Is it 
possible for the 0 at the end of an explicit constant string to get 
overwritten?  If it were the strncmp would be helpful, because the number 
of characters to consider would be determined at compile time.  If there 
is some problem with the name field, the strncmp will look at least to the 
end of "sysfs", so the strncmp won't help to keep the character accesses 
within the valid characters of name.

julia
