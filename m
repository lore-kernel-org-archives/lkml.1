Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883AbYJVFKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbYJVFKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 01:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbYJVFKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 01:10:14 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:30436 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbYJVFKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 01:10:12 -0400
Date: Tue, 21 Oct 2008 22:09:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 21 (printk format warnings)
Message-Id: <20081021220951.9f8b0760.randy.dunlap@oracle.com>
In-Reply-To: <20081022050142.GA11674@kroah.com>
References: <20081021195109.ed83b102.sfr@canb.auug.org.au>
	<20081021215725.b9c2b941.randy.dunlap@oracle.com>
	<20081022050142.GA11674@kroah.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.48FEB5A9.0049:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2008 22:01:42 -0700 Greg KH wrote:

> On Tue, Oct 21, 2008 at 09:57:25PM -0700, Randy Dunlap wrote:
> > On Tue, 21 Oct 2008 19:51:09 +1100 Stephen Rothwell wrote:
> > 
> > 
> > printk format warnings summary:
> > 
> > i386:
> > 
> > linux-next-20081021/drivers/pci/hotplug/acpiphp_ibm.c:207: warning: format '%08lx' expects type 'long unsigned int', but argument 3 has type 'long long unsigned int'
> > 
> > linux-next-20081021/drivers/misc/intel_menlow.c:107: warning: format '%ld' expects type 'long int', but argument 3 has type 'long long unsigned int'
> > 
> > x86_64:
> > 
> > linux-next-20081021/drivers/pci/hotplug/acpiphp_ibm.c:207: warning: format '%08lx' expects type 'long unsigned int', but argument 3 has type 'long long unsigned int'
> > 
> > linux-next-20081021/drivers/usb/misc/vstusb.c:623: warning: format '%d' expects type 'int', but argument 5 has type 'size_t'
> 
> Crap.  What's the expected modifier for "size_t" to work on all arches?
> 
> Same goes for the result of "size_of()", what should we use there?  Or
> are we just required to always cast things?

sizeof() is a type size_t.  Both of them should use "%zu".
ssize_t (signed) should use "%zd".

---
~Randy
