Return-Path: <linux-kernel-owner+w=401wt.eu-S1755447AbYIQWMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbYIQWMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 18:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbYIQWMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 18:12:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54903 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752789AbYIQWMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 18:12:40 -0400
Date: Wed, 17 Sep 2008 15:11:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: paul.moore@hp.com, sds@tycho.nsa.gov, jmorris@namei.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [Bug #11500] /proc/net bug related to selinux
Message-Id: <20080917151143.debb6adc.akpm@linux-foundation.org>
In-Reply-To: <m1vdwu4fku.fsf@frodo.ebiederm.org>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
	<1221483926.30816.18.camel@moss-spartans.epoch.ncsc.mil>
	<20080917125053.1f9ecf37.akpm@linux-foundation.org>
	<200809171724.36269.paul.moore@hp.com>
	<m1vdwu4fku.fsf@frodo.ebiederm.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2008 14:39:45 -0700
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Paul Moore <paul.moore@hp.com> writes:
> 
> > We suck?  Maybe, but some explanation about why we suck in this 
> > particular case would be helpful as far as I'm concerned.  I don't 
> > really care about identifying the guilty suckees, I'm more interested 
> > in finding out what happened to cause us to suck because of this.
> 
> Agreed.  I believe we carefully gave selinux the same paths for /proc/net
> that it had before so I don't know why this affects user space.
> 
> I know we had some selinux review when we made the change.
> 
> Eric

It's back up-thread somewhere.  umm...

On Mon, 15 Sep 2008 09:05:26 -0400
Stephen Smalley <sds@tycho.nsa.gov> wrote:

> However, the most likely explanation is simply that when /proc/net was
> changed from being a directory to being a symlink to /proc/self/net,
> that introduced an additional permission check on accesses
> of /proc/net/<whatever>, namely the read check on the symlink itself.
> And since that check wasn't happening on /proc/net accesses with older
> kernels, older policies didn't allow it.
