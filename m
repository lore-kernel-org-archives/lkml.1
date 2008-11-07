Return-Path: <linux-kernel-owner+w=401wt.eu-S1751709AbYKGB5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbYKGB5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 20:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbYKGB4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 20:56:48 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:52163 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbYKGB4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 20:56:44 -0500
Date: Thu, 06 Nov 2008 20:53:29 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 15/15] Revert "x86: default to reboot via ACPI"
In-reply-to: <20081107014342.GA9841@srcf.ucam.org>
X-X-Sender: lenb@localhost.localdomain
To: Matthew Garrett <mjg@redhat.com>
Cc: Robert Hancock <hancockr@shaw.ca>, Zhao Yakui <yakui.zhao@intel.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, Ingo Molnar <mingo@elte.hu>,
       Eduardo Habkost <ehabkost@redhat.com>, Avi Kivity <avi@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Message-id: <alpine.LFD.2.00.0811062049020.3106@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <fa.UVpnVba3yRAWG3rGZ0sk20JE9hs@ifi.uio.no>
 <fa.FPBNKx3BSvZHPZ+eXD4Tb+fuRYk@ifi.uio.no>
 <fa.PvVEuEo+f/t4sLmcGyN2Tsl8zYg@ifi.uio.no>
 <fa.zzFdOXisTZzBaE1+ueGIYmt+Z5c@ifi.uio.no>
 <fa.vQ6HVRcPFFr1zpcXFFOjEPtDdNk@ifi.uio.no>
 <fa.ckUqcrtVKbxAkjNggIdajBTHr9Q@ifi.uio.no> <49139A43.4000203@shaw.ca>
 <20081107014342.GA9841@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 7 Nov 2008, Matthew Garrett wrote:

> On Thu, Nov 06, 2008 at 07:30:43PM -0600, Robert Hancock wrote:
> 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8fd145917fb62368a9b80db59562c20576238f5a
> > 
> > This patch ignores the RESET_REG_SUP flag and just tries using the reset 
> > register anyway if it thinks it's valid. So we may attempt ACPI reset on 
> > machines which don't indicate it's supported.
> 
> Yeah, that sounds very wrong.

As it turns out, it was an incorrect guess on our part on how to be "bug 
compatible" and I'm reverting it per the regression report here:

http://bugzilla.kernel.org/show_bug.cgi?id=11942

-Len

> > The patch description mentioned that some machines didn't reboot after 
> > S3 suspend without this patch. However, we recently had this patch merged:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a68823ee5285e65b51ceb96f8b13a5b4f99a6888
> > 
> > Is it possible that the problem fixed there is the true cause of this 
> > reboot after S3 problem?
> 
> Oh, yeah, could be. Given the From:, I should really have thought of 
> that :)
> 
> -- 
> Matthew Garrett | mjg59@srcf.ucam.org
> 
