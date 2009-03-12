Return-Path: <linux-kernel-owner+w=401wt.eu-S1751512AbZCLDgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512AbZCLDgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 23:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbZCLDgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 23:36:16 -0400
Received: from kanga.kvack.org ([205.233.56.17]:38855 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbZCLDgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 23:36:16 -0400
Date: Wed, 11 Mar 2009 23:36:13 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Moyer <jmoyer@redhat.com>,
       Avi Kivity <avi@redhat.com>, linux-aio <linux-aio@kvack.org>,
       zach.brown@oracle.com, linux-kernel@vger.kernel.org,
       Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [patch] aio: remove aio-max-nr and instead use the memlock rlimit to limit the number of pages pinned for the aio completion ring
Message-ID: <20090312033613.GJ18665@kvack.org>
References: <x49bpsaelwa.fsf@segfault.boston.devel.redhat.com> <49B54143.1010607@redhat.com> <x49sklmd1fo.fsf@segfault.boston.devel.redhat.com> <49B57CB0.5020300@cosmosbay.com> <49B875F7.3030305@cosmosbay.com> <20090312024419.GG18665@kvack.org> <49B8807A.5080302@cosmosbay.com> <20090312032928.GH18665@kvack.org> <49B88280.8060603@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B88280.8060603@cosmosbay.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 04:33:20AM +0100, Eric Dumazet wrote:
> aio breaks the fget_light() concept too, if process is mono threaded.

AIO requests cannot use fget_light().  The user space program could very 
well use the close() syscall to destroy the file descriptor while an io 
request is in flight, so you cannot avoid the reference counting overhead.

		-ben
