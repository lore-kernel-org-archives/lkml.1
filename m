Return-Path: <linux-kernel-owner+w=401wt.eu-S1761654AbZJMXyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761654AbZJMXyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 19:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761640AbZJMXym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 19:54:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761638AbZJMXym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 19:54:42 -0400
Date: Tue, 13 Oct 2009 16:54:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ixj: Fix test in ixj_selfprobe()
Message-Id: <20091013165403.7e553eb7.akpm@linux-foundation.org>
In-Reply-To: <4ACB6684.5010108@gmail.com>
References: <4ACB6684.5010108@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Oct 2009 17:47:16 +0200
Roel Kluin <roel.kluin@gmail.com> wrote:

> Not makes it a bool before the comparison.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Was below intended?
> 
> diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
> index 40de151..da3c9a0 100644
> --- a/drivers/telephony/ixj.c
> +++ b/drivers/telephony/ixj.c
> @@ -6831,7 +6831,7 @@ static int ixj_selfprobe(IXJ *j)
>  	} else {
>  		switch (j->cardtype) {
>  		case QTI_PHONEJACK:
> -			if (!j->dsp.low != 0x20) {
> +			if (j->dsp.low != 0x20) {
>  				j->dsp.high = 0x80;
>  				j->dsp.low = 0x20;
>  				ixj_WriteDSPCommand(0x3800, j);

gee, I can't tell.  Presumably it'd be safer to just delete the test -
it's a no-op at present and that code is well-tested, lol.

