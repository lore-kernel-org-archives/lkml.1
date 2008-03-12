Return-Path: <linux-kernel-owner+w=401wt.eu-S1752380AbYCLSnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbYCLSnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 14:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbYCLSnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 14:43:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbYCLSnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 14:43:06 -0400
Subject: Re: [RFC] correct flags to f_mode conversion in __dentry_open
From: Eric Paris <eparis@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, alan <alan@redhat.com>, aviro@redhat.com,
       drepper@redhat.com, hch@infradead.org, sds@tycho.nsa.gov,
       jmorris@namei.org
In-Reply-To: <20080312183441.GJ27894@ZenIV.linux.org.uk>
References: <1205346327.5297.232.camel@localhost.localdomain>
	 <20080312183441.GJ27894@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Wed, 12 Mar 2008 14:41:00 -0400
Message-Id: <1205347260.2925.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-03-12 at 18:34 +0000, Al Viro wrote:
> On Wed, Mar 12, 2008 at 02:25:27PM -0400, Eric Paris wrote:
> > I recently tried to add an SELinux BUG_ON in the case where the kernel
> > made a permission request for no permissions and was able to stumble
> > over it with something as simple as
> > 
> > open("/dev/null", 3);
> > 
> > Notice that 3 == (O_RDWR | O_WRONLY)
> > 
> > First question, is 3 ever a valid flag from from userspace to sys_open?
> 
> Yes.  "Check for both read and write permissions, set neither FMODE_READ
> nor FMODE_WRITE".
> 
> Don't break drivers, please - some use that for "ioctl-only" opens,
> with special semantics for those.

Ok, I'll just make SELinux happy allow the request if we don't have
FMODE_READ or FMODE_WRITE set.

-Eric

