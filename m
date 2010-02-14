Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261Ab0BNFPj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 00:15:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58305 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870Ab0BNFPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 00:15:38 -0500
Message-ID: <4B778628.30206@zytor.com>
Date: Sat, 13 Feb 2010 21:12:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "rostedt@goodmis.org" <rostedt@goodmis.org>,
       "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [PATCH] x86_64: allow sections that are recycled to set _PAGE_RW
References: <1266030928-2126-1-git-send-email-konrad.wilk@oracle.com>	 <1266030928-2126-2-git-send-email-konrad.wilk@oracle.com> <1266091697.2677.64.camel@sbs-t61>
In-Reply-To: <1266091697.2677.64.camel@sbs-t61>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2010 12:08 PM, Suresh Siddha wrote:
>
> Checks in static_protections() ensure that we map the text mapping as
> read-only (and don't bother about what permissions it uses for
> underlying free pages that get freed in free_init_pages()). But the
> kernel direct mappings for free pages will be RW and ensure that the
> free pages can be read/written using the direct mapping.
>
> The checks in static_protections() for kernel text mapping ensure that
> we don't break the 2MB kernel text pages unnecessarily on 64bit kernels
> (as it has performance implications). We should be fine as long as the
> kernel identity mappings reflect the correct RW permissions.
>
> But somehow this is working fine on native kernels but not on Xen pv
> guest. Your patch will cause the performance issues that we are
> addressing using the static protections checks. I will look at this more
> detailed on tuesday.
>

Xen doesn't support PSE, so it has the (otherwise impossible) 
combination of PAE and !PSE ... i.e. it only uses 4K pages.

	-hpa
