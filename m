Return-Path: <linux-kernel-owner+w=401wt.eu-S1758780AbZFZJMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780AbZFZJMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 05:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757534AbZFZJMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 05:12:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36097 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757489AbZFZJME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 05:12:04 -0400
Date: Fri, 26 Jun 2009 10:13:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 3/9] x86/moorestown: add moorestown platform flags
Message-ID: <20090626101310.4110a290@lxorguk.ukuu.org.uk>
In-Reply-To: <20090626071955.GG14078@elte.hu>
References: <43F901BD926A4E43B106BF17856F07556412B7E2@orsmsx508.amr.corp.intel.com>
	<20090626071955.GG14078@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why dont we have some clean and robust PCI config space based 
> enumeration instead of this boot ID based thing?

That strikes me as a rather dumb question given that 

- Embedded x86 like devices are going to regularly occur without any PCI
- You need to know the platform in order to know how to access any PCI
  bus that may or may not hypothetically exist.

Take a look at how ARM and PPC address this. They do it via platform
features and descriptors for good reason.

One thing PPC does nice is to encapsulate pretty much all of it into a
struct of function pointers for each platform to keep the if conditionals
down. The ARM file layout of arch/foo/platform/bar might also be a good
idea before mrst and olpc and other stuff like this starts to make the
main x86 directory hard to read ?

Alan
