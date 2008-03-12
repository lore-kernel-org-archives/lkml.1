Return-Path: <linux-kernel-owner+w=401wt.eu-S1752553AbYCLSew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbYCLSew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 14:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYCLSeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 14:34:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49937 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbYCLSeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 14:34:44 -0400
Date: Wed, 12 Mar 2008 18:34:41 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, alan <alan@redhat.com>, aviro@redhat.com,
       drepper@redhat.com, hch@infradead.org, sds@tycho.nsa.gov,
       jmorris@namei.org
Subject: Re: [RFC] correct flags to f_mode conversion in __dentry_open
Message-ID: <20080312183441.GJ27894@ZenIV.linux.org.uk>
References: <1205346327.5297.232.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205346327.5297.232.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 02:25:27PM -0400, Eric Paris wrote:
> I recently tried to add an SELinux BUG_ON in the case where the kernel
> made a permission request for no permissions and was able to stumble
> over it with something as simple as
> 
> open("/dev/null", 3);
> 
> Notice that 3 == (O_RDWR | O_WRONLY)
> 
> First question, is 3 ever a valid flag from from userspace to sys_open?

Yes.  "Check for both read and write permissions, set neither FMODE_READ
nor FMODE_WRITE".

Don't break drivers, please - some use that for "ioctl-only" opens,
with special semantics for those.
