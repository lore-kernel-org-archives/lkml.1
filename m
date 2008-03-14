Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbYCNJS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbYCNJS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 05:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbYCNJSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 05:18:17 -0400
Received: from smtp-out.google.com ([216.239.45.13]:51128 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbYCNJSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 05:18:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=xZKRNkquMC2Y9PbCisDh8LlG84+sF4KhXlXsSJKiGQ/NJZhgaRA5q63xMXqoFVUhZ
	ifa4UKWMb/6zF6YK4PR9g==
Message-ID: <6599ad830803140218v3d9ca478ve41516a9ea627eb@mail.gmail.com>
Date: Fri, 14 Mar 2008 02:18:10 -0700
From: "Paul Menage" <menage@google.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [RFC] cgroups: implement device whitelist lsm (v2)
Cc: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       "Greg KH" <greg@kroah.com>, "Stephen Smalley" <sds@epoch.ncsc.mil>,
       "Casey Schaufler" <casey@schaufler-ca.com>,
       "Pavel Emelianov" <xemul@openvz.org>
In-Reply-To: <20080313032749.GA13258@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080313032749.GA13258@sergelap.austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 8:27 PM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> Implement a cgroup using the LSM interface to enforce mknod and open
>  on device files.
>
>  This implements a simple device access whitelist.  A whitelist entry
>  has 4 fields.  'type' is a (all), c (char), or b (block).  'all' means it
>  applies to all types, all major numbers, and all minor numbers.  Major and
>  minor are obvious.  Access is a composition of r (read), w (write), and
>  m (mknod).
>
>  The root devcgroup starts with rwm to 'all'.  A child devcg gets a copy
>  of the parent.  Admins can then add and remove devices to the whitelist.
>  Once CAP_HOST_ADMIN is introduced it will be needed to add entries as
>  well or remove entries from another cgroup, though just CAP_SYS_ADMIN
>  will suffice to remove entries for your own group.
>
>  An entry is added by doing "echo <type> <maj> <min> <access>" > devcg.allow,
>  for instance:
>
>         echo b 7 0 mrw > /cgroups/1/devcg.allow
>
>  An entry is removed by doing likewise into devcg.deny.  Since this is a
>  pure whitelist, not acls, you can only remove entries which exist in the
>  whitelist.  You must explicitly
>
>         echo a 0 0 mrw > /cgroups/1/devcg.deny
>
>  to remove the "allow all" entry which is automatically inherited from
>  the root cgroup.

In keeping with the naming convention for control groups, "devices"
would be better than "devcg".

Paul
