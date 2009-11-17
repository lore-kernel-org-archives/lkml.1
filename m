Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbZKQRsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbZKQRsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:48:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbZKQRsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:48:12 -0500
Received: from xenotime.net ([72.52.64.118]:55644 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753927AbZKQRsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:48:11 -0500
Date: Tue, 17 Nov 2009 09:48:12 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 17 (exofs)
Message-Id: <20091117094812.97775988.rdunlap@xenotime.net>
In-Reply-To: <4B02DC46.5060202@panasas.com>
References: <20091117195309.6cc3ead0.sfr@canb.auug.org.au>
	<20091117090248.bb66c230.rdunlap@xenotime.net>
	<4B02D879.4010403@panasas.com>
	<4B02D8F9.2090208@panasas.com>
	<4B02DC46.5060202@panasas.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Nov 2009 19:24:22 +0200 Boaz Harrosh wrote:

> On 11/17/2009 07:10 PM, Boaz Harrosh wrote:
> > On 11/17/2009 07:08 PM, Boaz Harrosh wrote:
> >> On 11/17/2009 07:02 PM, Randy Dunlap wrote:
> >>> On Tue, 17 Nov 2009 19:53:09 +1100 Stephen Rothwell wrote:
> >>>
> >>>> Hi all,
> >>>>
> >>>> Changes since 20091116:
> >>>
> >>>
> >>> on i386 (X86_32):
> >>>
> >>> fs/built-in.o: In function `exofs_sbi_read':
> >>> (.text+0x592964): undefined reference to `__umoddi3'
> >>>
> >>> ---
> >>> ~Randy
> >>
> >> exofs_sbi_read is a totally simple loop thing. What does the
> >> __umoddi3 means? Please help?
> >>
> >> Boaz
> > 
> > OK I think I get it. It's that u64 mod (%) operation. I'll try to
> > find a ready made macro for that. Sorry
> > 
> > Boaz
> > 
> 
> I'll push this fix for tomorrow. Thanks for helping me find it.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks!


> 4G devices is more than enough thank you ;-)
> 
> Boaz
> ---
> git diff --stat -p -M fs/exofs/ios.c
>  fs/exofs/ios.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/exofs/ios.c b/fs/exofs/ios.c
> index 14b2600..5bad01f 100644
> --- a/fs/exofs/ios.c
> +++ b/fs/exofs/ios.c
> @@ -320,8 +320,9 @@ int exofs_sbi_read(struct exofs_io_state *ios)
>  
>  	for (i = 0; i < 1; i++) {
>  		struct osd_request *or;
> -		unsigned first_dev = ios->obj.id % ios->sbi->s_numdevs;
> +		unsigned first_dev = (unsigned)ios->obj.id;
>  
> +		first_dev %= ios->sbi->s_numdevs;
>  		or = osd_start_request(ios->sbi->s_ods[first_dev], GFP_KERNEL);
>  		if (unlikely(!or)) {
>  			EXOFS_ERR("%s: osd_start_request failed\n", __func__);
> 


---
~Randy
