Return-Path: <linux-kernel-owner+w=401wt.eu-S1758017AbYGJPMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbYGJPMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 11:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755629AbYGJPMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 11:12:06 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:20860 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147AbYGJPMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 11:12:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HbwMOrP4perQx3v82E2XON+SPXLYiKb6nsIwJUJ7Bt7q9CLD7DEt2rbz8pR0S90kwX
         +FnLdOPk1kJAt2X7pYqfoPAYk1btngQlqVPBBaeJ21uavMGG1ptEjLvg+BemQc1qBuE7
         qRRyJ5XHLy6j2BV24Ar0LcBJB4aNZziD/5Kks=
Date: Thu, 10 Jul 2008 11:11:58 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pavel Machek <pavel@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Shaohua Li <shaohua.li@intel.com>, Len Brown <lenb@kernel.org>,
       jikos@suse.cz
Subject: Re: [PATCH -mm 4/8] serio: Speed-up resume
Message-ID: <20080710151158.GA4332@anvil.corenet.prv>
References: <200807100152.17755.rjw@sisk.pl> <200807100201.56232.rjw@sisk.pl> <20080710113535.GD15412@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080710113535.GD15412@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 01:35:35PM +0200, Pavel Machek wrote:
> On Thu 2008-07-10 02:01:55, Rafael J. Wysocki wrote:
> > From: Shaohua Li <shaohua.li@intel.com>
> > Subject: serio: Speed-up resume
> > 
> > serio_resume will call into psmouse_extensions(). In my test, the
> > routine is very slow, it blocks resume about 1 sec. Below patch (move
> > resume to kseriod, just like boot time probe) cures the issue in my
> > test, and seems no side effect. I'm no familiar with serio driver, so
> > please check. 
> > 
> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > Acked-by: Len Brown <lenb@kernel.org>
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Cc: Jiri Kosina <jikos@suse.cz>
> 
> ACK from me, but I'm not a serio expert.
> 								Pavel

I think the patch makes sense, maybe it will even help with resume in
general when we fail to resume for some reason and then when they reload
drivers after the system is fully up it magically starts workign again.
It is in my 'master' branch from which Andrew is pulling into -mm. I
will let it sit there for a bit though.

-- 
Dmitry
