Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbYHNQQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbYHNQQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 12:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYHNQP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 12:15:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751373AbYHNQP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 12:15:57 -0400
Date: Thu, 14 Aug 2008 09:15:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Trevor Woollacott [ MTN - Innovation Centre ]" <Woolla_T@mtn.co.za>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: POSIX_FADV_DONTNEED
Message-Id: <20080814091521.e4d9be53.akpm@linux-foundation.org>
In-Reply-To: <70D00C33FCD1FD4A860DEAC228277C0C048425EA@MTNMAIL1.mtn.co.za>
References: <70D00C33FCD1FD4A860DEAC228277C0C048425D1@MTNMAIL1.mtn.co.za>
	<20080814021703.355b2a76.akpm@linux-foundation.org>
	<70D00C33FCD1FD4A860DEAC228277C0C048425EA@MTNMAIL1.mtn.co.za>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008 12:26:28 +0200 "Trevor Woollacott [ MTN - Innovation Centre ]" <Woolla_T@mtn.co.za> wrote:

> 
> > On Fri, 1 Aug 2008 17:05:39 +0200 "Trevor Woollacott [ MTN - Innovation
> > Centre ]" <Woolla_T@mtn.co.za> wrote:

(please don't top-post).

> > > 
> > > Hi all
> > > 
> > > Does anyone know if posix_fadvise() with POSIX_FADV_DONTNEED is
> > > blocking/unblocking?
> > 
> > It tries to be nonblocking and will mostly succeed in that.  It might
> > occasionally block on a metadata read or journal congestion or
> > something, so it isn't guaranteed.
> >
>
> Thanks for the response Andrew. Is there a way to check when the cached
> data has been freed after fadvise has been called?
> 

I assume you meant "whether", not "when".

Not directly.  I believe that the best way of obtaining that
information remains mmap()ing the file then querying the presence of
pages via mincore().
