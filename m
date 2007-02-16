Return-Path: <linux-kernel-owner+w=401wt.eu-S932503AbXBPRSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503AbXBPRSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 12:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932493AbXBPRSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 12:18:39 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:33212 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932503AbXBPRSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 12:18:39 -0500
X-Greylist: delayed 1672 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Feb 2007 12:18:38 EST
Date: Fri, 16 Feb 2007 10:50:42 -0600
From: Robin Holt <holt@sgi.com>
To: David Howells <dhowells@redhat.com>
Cc: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Robin Holt <holt@sgi.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>
Subject: Re: [PATCH 3/4] coredump: ELF-FDPIC: enable to omit anonymous shared memory
Message-ID: <20070216165042.GB409@lnx-holt.americas.sgi.com>
References: <45D5B483.3020502@hitachi.com> <45D5B2E3.3030607@hitachi.com> <20368.1171638335@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20368.1171638335@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 03:05:35PM +0000, David Howells wrote:
> Actually, I think I would just pass the mm pointer you have into maydump() and
> let that dereference it here:
> 
> > +		if (omit_anon_shared) {
> 
> which would then be:
> 
> 		if (mm->coredump_omit_anon_shared) {

How about:
		if (vma->vm_mm->coredump_omit_anon_shared) {

Then the calls to maydump() would be unchanged:
