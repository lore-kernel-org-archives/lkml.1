Return-Path: <linux-kernel-owner+w=401wt.eu-S1760371AbYBABmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760371AbYBABmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 20:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbYBABmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 20:42:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:16588 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbYBABmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 20:42:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,287,1199692800"; 
   d="scan'208";a="294783800"
Subject: Re: [PATCH 2.6.24] Add new string functions real_strtoul and
	change kernel params to use them
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20080131090345.92bce974.randy.dunlap@oracle.com>
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com>
	 <1201043126.3861.5.camel@yangyi-dev.bj.intel.com>
	 <1201562058.12722.9.camel@yangyi-dev.bj.intel.com>
	 <1201650080.3875.1.camel@yangyi-dev.bj.intel.com>
	 <1201742302.6500.7.camel@yangyi-dev.bj.intel.com>
	 <20080131090345.92bce974.randy.dunlap@oracle.com>
Content-Type: text/plain
Organization: Intel
Date: Fri, 01 Feb 2008 00:30:17 +0800
Message-Id: <1201797017.6500.16.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-31 at 09:03 -0800, Randy Dunlap wrote:
> On Thu, 31 Jan 2008 09:18:22 +0800 Yi Yang wrote:
> 
> > Currently, for every sysfs node, the callers will be responsible for
> > implementing store operation, so many many callers are doing duplicate
> > things to validate input, they have the same mistakes because they are
> > calling simple_strtol/ul/ll/ull, especially for module params, they are
> > just numeric, but you can echo such values as 0x1234xxx, 07777888 and
> > 1234aaa, for these cases, module params store operation just ignores
> > successive invalid char and converts prefix part to a numeric although
> > input is actually invalid.
> > 
> > This patch tries to fix the aforementioned issues and implements real_strtox
> > serial functions, kernel/params.c uses them to strictly validate input,
> > so module params will reject such values as 0x1234xxxx and returns an error:
> 
> How about a prefix of safe_ or strict_ or something other than real_?
> real_ sounds too much like a real number function string parser.
> 
I named it as strict_ at the beginning, but it results in some alignment
issues checkpatch.pl will always warn, i don't know if warnings will
make the patch out of the door.

In kernel/params.c, STANDARD_PARAM_DEF(a function definition macro) will
be over 80 chars, is it correct coding style to split it to two lines?

