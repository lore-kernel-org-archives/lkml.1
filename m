Return-Path: <linux-kernel-owner+w=401wt.eu-S1764310AbYFFHmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764310AbYFFHmB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 03:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbYFFHlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 03:41:49 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:50272 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682AbYFFHls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 03:41:48 -0400
Subject: Re: kvm causing memory corruption?  now 2.6.26-rc4
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm@vger.kernel.org>,
       "Anthony N. Liguori [imap]" <aliguori@us.ibm.com>
In-Reply-To: <48469BDA.3050206@qumranet.com>
References: <1206479576.7562.21.camel@nimitz.home.sr71.net>
	 <47EA1C63.8010202@qumranet.com>
	 <1206550329.7883.5.camel@nimitz.home.sr71.net>
	 <47EA80AC.4070204@qumranet.com>
	 <1206551794.7883.7.camel@nimitz.home.sr71.net>
	 <47EB6AAC.3040607@qumranet.com>  <47EB7281.6070300@qumranet.com>
	 <1206629709.7883.30.camel@nimitz.home.sr71.net>
	 <47EBB63E.2060306@qumranet.com>
	 <1212445810.8211.9.camel@nimitz.home.sr71.net>
	 <48469BDA.3050206@qumranet.com>
Content-Type: text/plain
Date: Fri, 06 Jun 2008 00:41:45 -0700
Message-Id: <1212738105.7837.3.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-04 at 16:42 +0300, Avi Kivity wrote:
> Dave Hansen wrote:
...
> > After collecting all those, I turned on CONFIG_DEBUG_HIGHMEM and the
> > oopses miraculously stopped.  But, the guest hung (for at least 5
> > minutes or so) during windows bootup, pegging my host CPU.  Most of the
> > CPU was going to klogd, so I checked dmesg.
> >
> Can you check with mem=900 (and CONFIG_HIGHMEM_DEBUG=n)?  That will 
> confirm that the problems are highmem related, but not physical address 
> truncation related.

Do you mean 800M? ;) Highmem begins at 896MB if I remember correctly.

Anyway, it still oopses on current git with mem=800M

> > I was seeing messages like this
> >
> > [  428.918108] kvm_handle_exit: unexpected, valid vectoring info and exit reason is 0x9
> >
> > And quite a few of them, like 100,000/sec.  That's why klogd was pegging
> > the CPU.  Any idea on a next debugging step?
> >
> That's a task switch.  Newer kvms handle them.

Newer userspace?  I'm running current kvm-git userspace as of a day or
two ago.

-- Dave

