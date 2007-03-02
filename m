Return-Path: <linux-kernel-owner+w=401wt.eu-S2992621AbXCBQ4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992621AbXCBQ4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 11:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992619AbXCBQ4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 11:56:07 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:33260 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992617AbXCBQ4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 11:56:02 -0500
X-AuditID: d80ac21c-9559dbb000007de4-88-45e857198e68 
Date: Fri, 2 Mar 2007 16:55:53 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: David Howells <dhowells@redhat.com>
cc: Robin Holt <holt@sgi.com>,
       "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>
Subject: Re: [PATCH 3/4] coredump: ELF-FDPIC: enable to omit anonymous shared
 memory 
In-Reply-To: <18817.1171656543@redhat.com>
Message-ID: <Pine.LNX.4.64.0703021646050.13167@blonde.wat.veritas.com>
References: <20070216165042.GB409@lnx-holt.americas.sgi.com> 
 <45D5B483.3020502@hitachi.com> <45D5B2E3.3030607@hitachi.com>
 <20368.1171638335@redhat.com>  <18817.1171656543@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 02 Mar 2007 16:55:53.0117 (UTC) FILETIME=[A35C8CD0:01C75CEB]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007, David Howells wrote:
> Robin Holt <holt@sgi.com> wrote:
> 
> > How about:
> > 		if (vma->vm_mm->coredump_omit_anon_shared) {
> > 
> > Then the calls to maydump() would be unchanged:
> 
> VMAs are a shared resource under NOMMU conditions.

That's a disturbing remark.  Under precisely what NOMMU conditions?

I had thought Robin's suggestion very sensible; and throughout mm/
it has seemed pretty random whether we pass an "mm" argument down
in addition to "vma", or just take vma->vm_mm at whatever level needs.

You seem to be suggesting vma->vm_mm is dangerous when CONFIG_NOMMU,
but we MMU people are scarily unaware of that.  Perhaps you need to
put #ifndef CONFIG_NOMMU around vm_mm in struct vm_area_struct?

Or am I totally misunderstanding?

Hugh
