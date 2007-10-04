Return-Path: <linux-kernel-owner+w=401wt.eu-S1762676AbXJDXY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762676AbXJDXY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 19:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756799AbXJDXYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 19:24:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44287 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752978AbXJDXYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 19:24:15 -0400
Date: Thu, 4 Oct 2007 16:22:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/2] getattr - fill the size of pipes
Message-Id: <20071004162252.f0785c9f.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0710021952450.7130@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710021952450.7130@fbirervta.pbzchgretzou.qr>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2007 19:54:53 +0200 (CEST)
Jan Engelhardt <jengelh@computergmbh.de> wrote:

> [PATCH]: Fill the size of pipes
> 
> Instead of reporting 0 in size when stating() a pipe, we give the number of
> queued bytes. This might avoid using ioctl(FIONREAD) to get this information.
> 
> References and derived from: http://lkml.org/lkml/2007/4/2/138
> Cc: Eric Dumazet <dada1@cosmosbay.com>
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>


Cute feature, but it is (I assume) a Linux-specific extension and is
something which we'll need to maintain for ever and it invites
unportability to older Linuxes and other OSes and it introduces some risk
of breakage of existing applications.  And it slows down fstat on a pipe.

Given that the info can already be obtained via ioctl(FIONREAD) anyway, I
don't think that (gain > pain)?

