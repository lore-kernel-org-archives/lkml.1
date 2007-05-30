Return-Path: <linux-kernel-owner+w=401wt.eu-S1760570AbXE3Vrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760570AbXE3Vrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760193AbXE3Vqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:46:42 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760183AbXE3Vql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:46:41 -0400
Date: Wed, 30 May 2007 14:46:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelianov <xemul@openvz.org>
Cc: Paul Menage <menage@google.com>, Balbir Singh <balbir@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH 5/8] RSS accounting hooks over the code
Message-Id: <20070530144629.09dad0df.akpm@linux-foundation.org>
In-Reply-To: <465D997A.3030706@openvz.org>
References: <465D9739.8070209@openvz.org>
	<465D997A.3030706@openvz.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007 19:34:18 +0400
Pavel Emelianov <xemul@openvz.org> wrote:

> As described above, pages are charged to their first touchers.
> The first toucher is determined using pages' _mapcount 
> manipulations in rmap calls.
> 
> Page is charged in two stages:
> 1. preparation, in which the resource availability is checked.
>    This stage may lead to page reclamation, thus it is performed
>    in a "might-sleep" places;
> 2. the container assignment to page. This is done in an atomic
>    code that handles races between multiple touchers.

I suppose we need to think about what to do about higher-order pages, and
compound pages, and hugetlb memory.
