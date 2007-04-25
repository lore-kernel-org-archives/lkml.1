Return-Path: <linux-kernel-owner+w=401wt.eu-S1753558AbXDYTyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbXDYTyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 15:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbXDYTyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 15:54:55 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60830 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753558AbXDYTyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 15:54:54 -0400
Date: Wed, 25 Apr 2007 12:54:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Pavel Emelianov <xemul@sw.ru>
Subject: Re: 2.6.21-rc7-mm1: Oops and Gnome desktop freezes
Message-Id: <20070425125406.9253bd49.akpm@linux-foundation.org>
In-Reply-To: <20070425193511.GB3006@redhat.com>
References: <1177512596.4856.17.camel@daplas>
	<20070425121242.52698643.akpm@linux-foundation.org>
	<20070425193511.GB3006@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007 15:35:11 -0400 Dave Jones <davej@redhat.com> wrote:

> On Wed, Apr 25, 2007 at 12:12:42PM -0700, Andrew Morton wrote:
>   > > EIP:    0060:[<c014c469>]    Tainted: G      D VLI
>  > 
>  > For some reason all oopses (and boy there are a lot of them) are being
>  > described as tainted.
> 
> What's "D" though ?

Pretty flattering, if it's on a scale of A-F.

>  grep -i taint broken-out/* doesn't show
> -mm adding any new flags, and I don't see it present in mainline.

report-that-kernel-is-tainted-if-there-were-an-oops-before.patch:

+  8: 'D' if a kernel has died recently, i.e. there was an OOPS or BUG
+      before, ' ' otherwise. This is useful when seeing the calltrace
+      from SysRq-P output.

I suspect that patch has gone bad and it's reporting 'D' for the very first
oops, which it shouldn't do.

But I haven't checked that theory.
