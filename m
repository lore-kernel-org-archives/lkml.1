Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567AbZKCTIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbZKCTIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 14:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754166AbZKCTId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 14:08:33 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34110 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751336AbZKCTId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 14:08:33 -0500
Date: Tue, 3 Nov 2009 19:10:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       James Bottomley <James.Bottomley@suse.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] strstrip incorrectly marked __must_check
Message-ID: <20091103191006.30e8be36@lxorguk.ukuu.org.uk>
In-Reply-To: <20091103190420.GY10555@parisc-linux.org>
References: <1257273488.9427.27.camel@mulgrave.site>
	<20091103105921.160d5599.akpm@linux-foundation.org>
	<20091103190420.GY10555@parisc-linux.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Nov 2009 12:04:20 -0700
Matthew Wilcox <matthew@wil.cx> wrote:

> 
>  static inline void strsrip_tail(char *str)
>  {
> -	char *x __used;
> -	x = strstrip(str);
> +	char *x = strstrip(str);
> +	BUG_ON(x != str);

That breaks it. It was fine before you did that but now it blows up if
there are leading spaces.
